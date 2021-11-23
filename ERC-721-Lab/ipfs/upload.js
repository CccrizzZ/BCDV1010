const { create } = require("ipfs-http-client");

// create inter-planetary file system obj
// using infura gateway ipfs here
// https://ipfs.github.io/public-gateway-checker/
const ipfs = create("https://ipfs.infura.io:5001");

// function that uploads NFT
async function run() {

    // construct NFT file details
    const files = [{
        path: '/',
        content: JSON.stringify({
            name: "electro-palace",
            attributes: [
                {
                    "water": "purple",
                    "value": "100"
                },
                {
                    "macintosh": "golden",
                    "value": "2"
                },
                {
                    "column": "golden",
                    "value": "1"
                }
            ],
            image: "https://gateway.pinata.cloud/ipfs/QmS2U2VGE8BKajbSYN1iXPqUmv7bZ8eqsvhZ8sucZHURcw",    // a piece of art created by me (@CccrizzZ)
            description: "drip with macintosh in the palace"
        })
    }];



    // add the NFT file to ipfs
    const result = await ipfs.add(files);
    console.log(result);

    // upload result
    // {
    //     path: 'QmR4PEH7LPZb6eSd8Yiy46mzHQjAXAimm6UE2mfqgyPq94',
    //     cid: CID(QmR4PEH7LPZb6eSd8Yiy46mzHQjAXAimm6UE2mfqgyPq94),
    //     size: 292
    // }

}

run();