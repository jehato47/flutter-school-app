const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
    .document("notification/{notification}")
    .onCreate((snapshot, context)=>{
      console.log(snapshot.data());
      return admin.messaging().sendToTopic("11-a", {
        notification: {
          title: snapshot.data().text,
          body: snapshot.data().creator,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });
