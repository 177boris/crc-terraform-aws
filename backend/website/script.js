console.log("U got a visitor! ");


fetch("https://n2qzz2oz7d.execute-api.eu-west-2.amazonaws.com/serverless_lambda_stage/count")
        .then(response => response.json())
        .then((data) => {
        console.log(data)
        document.getElementById("visitorCount").innerText = data.message
        })
