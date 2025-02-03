const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const { GoogleAuth } = require('google-auth-library');
require('dotenv').config();
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const upload = multer({ dest: 'uploads/' });

const projectId = process.env.PROJECT_ID;
const location = process.env.LOCATION;
const processorId = process.env.PROCESSOR_ID;
const keyFilePath = process.env.GOOGLE_APPLICATION_CREDENTIALS;

async function processDocument(filePath) {
    const auth = new GoogleAuth({
        keyFile: keyFilePath,
        scopes: ['https://www.googleapis.com/auth/cloud-platform'],
    });
    const client = await auth.getClient();
    const url = `https://${location}-documentai.googleapis.com/v1/projects/${projectId}/locations/${location}/processors/${processorId}:process`;

    const image = fs.readFileSync(filePath).toString('base64');

    const response = await client.request({
        url,
        method: 'POST',
        data: {
            rawDocument: {
                content: image,
                mimeType: 'image/jpeg',
            },
        },
    });

    return response.data;
}

app.post('/upload', upload.single('image'), async (req, res) => {
    if (!req.file) return res.status(400).send('No file uploaded.');

    try {
        const result = await processDocument(req.file.path);
        res.json({ extractedText: result });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
});

app.listen(3000, () => console.log('Server running on port 3000'));
