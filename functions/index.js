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

exports.myFunction2 = functions.firestore
    .document("homework/{homework}")
    .onCreate((snapshot, context)=>{
      console.log(snapshot.data());
      return admin.messaging().sendToTopic("11-a", {
        notification: {
          title: "Ödev",
          body: snapshot.data().ödev,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
          image: "https://34co0u35pfyt37c0y0457xcu-wpengine.netdna-ssl.com/wp-content/uploads/2017/12/education_inequity_and_homework.jpg",
        },
      });
    });
