const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp()




    




exports.addNewContact = functions.firestore.document('addContactRequest/{docId}')
                                    .onCreate(async (snap, _) => {
                                        const userId = snap.data()
                                        console.log(userId)/*
                                        const contactUsername = change.data.arguments['contactUsername']
                                        
                                        
                                        //asd
                                        
                                        console.log("asdf")
                                        
                                        const checks = [
                                            checkContactUsernameExists(contactUsername),
                                            checkContactNotAdded(userId, contactUsername)
                                        ]
                                        const [contactUsernameExists, ContactNotAdded] = await Promise.all(checks)

                                        if(!contactUsernameExists) {
                                            await response('addContactResponse/'+userId+'/responses', {'contactUsernameExists': false})
                                        }*/


                                    })
                                
/*
exports.createAccount = functions.auth.user().onCreate((user) => {
    return admin.firestore().doc('users/'+user.uid).set({'username': user.email.split('@')[0]})
})



async function response(dbPath, params){
    admin.firestore().collection(dbPath).add(params)

}*/