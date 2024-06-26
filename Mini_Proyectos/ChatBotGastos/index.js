// https://www.youtube.com/live/pBB1pMOUUq4

const { google } = require('googleapis');
const TelegramBot = require('node-telegram-bot-api');
require('dotenv').config();

const telegramToken = process.env.TELEGRAM_BOT_TOKEN;
const spreadSheetId = process.env.GOOGLE_SHEET_ID;
const googleCredentials = require(process.env.GOOGLE_CREDENTIALS_PATH);

const bot = new TelegramBot(telegramToken, { polling: true });

async function initGoogleSheets() {
    const auth = new google.auth.GoogleAuth({
        credentials: {
            client_email: googleCredentials.client_email,
            private_key: googleCredentials.private_key
        },
        scopes: 'https://www.googleapis.com/auth/spreadsheets'
    });

    const client = await auth.getClient();
    const sheets = google.sheets({ version: 'v4', auth: client });

    return sheets;
}

bot.on('message', async (msg) => {
    console.log("HOLA");

    const chatId = msg.chat.id;
    const message = msg.text;
    console.log(msg.text);

    let [amount, category] = message.split(' '); //120 otros

    category = category || 'Otros';

    try {
        const sheets = await initGoogleSheets();
        await sheets.spreadsheets.values.append({
            spreadsheetId: spreadSheetId,
            range: "Hoja 1",
            valueInputOption: "USER_ENTERED",
            resource: {
                values: [[ category, amount ]]                
            },
            insertDataOption: 'INSERT_ROWS'
        });

        bot.sendMessage(chatId, "Tu gasto se ha registrado guachím!");
    }
    catch(err) {
        console.error(err);
        bot.sendMessage(chatId, "Todo está perdido");
    }
});

//initGoogleSheets();
console.log("Running Bot [ *_-_* ] ");
