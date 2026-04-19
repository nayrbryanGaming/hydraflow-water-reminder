const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

// Calculates streak when a new hydration log is added
exports.onHydrationLogAdded = functions.firestore
    .document("users/{userId}/hydration_logs/{logId}")
    .onCreate(async (snap, context) => {
      const {userId} = context.params;
      const newLog = snap.data();

      if (!newLog || !newLog.amount_ml) return null;

      const userRef = db.collection("users").doc(userId);
      const userDoc = await userRef.get();
      if (!userDoc.exists) return null;

      const userData = userDoc.data();
      const goalMl = userData.daily_water_goal_ml || 2000;

      // Start transaction to update stats
      return db.runTransaction(async (transaction) => {
        const statsRef = userRef.collection("achievements").doc("stats");
        const statsDoc = await transaction.get(statsRef);

        let totalWaterMl = newLog.amount_ml;
        
        if (statsDoc.exists) {
           const statsData = statsDoc.data();
           totalWaterMl += (statsData.total_water_ml || 0);
        }

        const updateData = {
          total_water_ml: totalWaterMl,
          last_log_timestamp: admin.firestore.FieldValue.serverTimestamp(),
          user_id: userId
        };

        transaction.set(statsRef, updateData, {merge: true});
      });
    });

// Automatic User Data Cleanup on Account Deletion
exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  const userId = user.uid;
  console.log(`User ${userId} deleted. Starting recursive data purge...`);

  const userRef = db.collection("users").doc(userId);
  
  // 1. Delete Subcollections (Logs, Reminders, Achievements)
  // Note: For massive subcollections, use firebase-admin's recursive delete
  const collections = ["hydration_logs", "reminders", "achievements"];
  
  for (const collectionName of collections) {
    const snapshot = await userRef.collection(collectionName).get();
    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
      batch.delete(doc.ref);
    });
    await batch.commit();
    console.log(`Deleted collection: ${collectionName} for user ${userId}`);
  }

  // 2. Delete Main User Document
  await userRef.delete();
  console.log(`Successfully purged all data for user ${userId}`);
  return null;
});

// End of Cloud Functions
