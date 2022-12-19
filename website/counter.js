function visitorCount(){

        console.log("U got a visitor! ");

        apiURL = "https://751agvrfn5.execute-api.us-east-1.amazonaws.com/serverless_lambda_stage/count"

        fetch(apiURL).then(response => 
                response.json()).then((data) => {
                document.getElementById("visitorCount").innerHTML = data.count
                });
}


window.onload = visitorCount();