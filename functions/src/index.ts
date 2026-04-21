import { onCallGenkit } from "@genkit-ai/firebase/functions";
import { genkit, z } from "genkit";
import { googleAI, gemini15Flash } from "@genkit-ai/googleai";
import * as admin from "firebase-admin";

admin.initializeApp();

// Initialize the Genkit instance
const ai = genkit({
    plugins: [googleAI()],
    model: gemini15Flash,
});

// Define the Menu Chat Flow
export const menuChatFlow = ai.defineFlow(
    {
        name: "menuChatFlow",
        inputSchema: z.string(),
        outputSchema: z.string(),
    },
    async (input) => {
        // A simple conversational generation for now.
        // In the next phase, we can add tools to fetch firestore data
        const { text } = await ai.generate({
            prompt: `You are a helpful assistant for a high-end cafe called "Boutique Cafe System". 
            Answer the user in a friendly, concise, and helpful tone.
            User: ${input}`,
        });

        return text;
    }
);

// Expose the Genkit flow as a callable function (accessible from Flutter app via cloud_functions)
export const chatWithAgent = onCallGenkit(
    {
        authPolicy: () => true, // Allow open access for testing
    },
    menuChatFlow
);
