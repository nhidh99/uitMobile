function getToday() {
    const today = new Date();
    const yesterday = new Date();
    yesterday.setDate(today.getDate() - 1);
    const dd = String(yesterday.getDate()).padStart(2, '0');
    const mm = String(yesterday.getMonth() + 1).padStart(2, '0');
    const yyyy = yesterday.getFullYear();
    output = yyyy + "-" + mm + "-" + dd;
    console.log(output);
    return output;
}

const rootURL = 'https://www.alphavantage.co/query';
const apiKey = 'XPS5YNXCJSUJGZI1';


export default async function StockAPI(code) {
    const url = `${rootURL}?apikey=${apiKey}&function=TIME_SERIES_DAILY_ADJUSTED&symbol=${code}`;
    console.log(url);
    const response = await fetch(url);
    const text = await response.text();
    const json = JSON.parse(text);
    const today = getToday();

    const data = json["Time Series (Daily)"][today];
    const open = parseFloat(data["1. open"]);
    const close = parseFloat(data["4. close"]);
    const changeRaw = close - open;
    const changePercent = close / open - 1;

    return {
        stockIndex: close.toFixed(2),
        stockChangeRaw: (changeRaw >= 0 ? '+' : '') + changeRaw.toFixed(2),
        stockChangePercent: (changePercent >= 0 ? '+' : '') + changePercent.toFixed(2)
    };
}