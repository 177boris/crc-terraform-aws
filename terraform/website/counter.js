function visitorCount(){

        console.log("U got a visitor! ");

        apiURL = "https://ilf56mrs79.execute-api.eu-west-2.amazonaws.com/serverless_lambda_stage/count"

        fetch(apiURL).then(response => 
                response.json()).then((data) => {
                document.getElementById("visitorCount").innerHTML = data.count
                });
}


window.onload = visitorCount();