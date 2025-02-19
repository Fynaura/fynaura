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
        scopes: ["https://www.googleapis.com/auth/cloud-platform"],
    });
    const client = await auth.getClient();
    const url = "https://us-documentai.googleapis.com/v1/projects/664418100697/locations/us/processors/bc3ca3fc5c5ae263:process";

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

    console.log("Image received:", req.file.path);

    try {
        const result = await processDocument(req.file.path);

        // Extract text from response
        const extractedText = result.document?.text || "No text found";

        // Extract total amount using Document AI
        let totalAmount = "Total not found";
        if (result.document?.entities) {
            const amountEntity = result.document.entities.find(entity => entity.type.toLowerCase().includes("total"));
            if (amountEntity) {
                totalAmount = amountEntity.mentionText || "Total not found";
            }
        }

        console.log(`Extracted Text: ${extractedText}`);
        console.log(`Total Amount: ${totalAmount}`);

        // Remove the uploaded file after processing
        fs.unlinkSync(req.file.path);

        res.json({ extractedText,totalAmount });
    } catch (error) {
        console.error("Error processing document:", error);
        res.status(500).json({ error: error.message });
    }
});

app.listen(3000, () => console.log('Server running on port 3000'));
