const admin = require('firebase-admin');
const fs = require('fs');

// 1. Initialize Admin SDK (You'll need a Service Account Key)
// Go to Firebase Console > Project Settings > Service Accounts > Generate New Private Key
const serviceAccount = require("./service-account-key.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// 2. Path to your exported data (Look inside your antigravity_data folder)
// It usually looks like: ./antigravity_data/firestore_export/all_namespaces/all_kinds/all_namespaces_all_kinds.json
const data = JSON.parse(fs.readFileSync('./path_to_your_data.json', 'utf8'));

async function upload() {
    for (const doc of data) {
        await db.collection('antigravity').add(doc);
        console.log('Uploaded one antigravity document!');
    }
}

upload();