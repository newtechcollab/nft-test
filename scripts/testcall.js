const https = require('https');

// Sample URL
const url = 'https://gateway.pinata.cloud/ipfs/QmUDzZxanc2sAbfLWixW5yrV63nStkiatKVufYHazW6Wj8';

const request = https.request(url, (response) => {
	let data = '';
	response.on('data', (chunk) => {
		data = data + chunk.toString();
	});

	response.on('end', () => {
		const body = JSON.parse(data);
		console.log(body);
	});
})

request.on('error', (error) => {
	console.log('An error', error);
});

request.end()
