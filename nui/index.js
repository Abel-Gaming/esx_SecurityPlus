window.onload = function(){ 
    $('.ContractPanel').hide();
    document.getElementById('AllContracts').hidden = true;
}

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'display') {
        if (data.showUI) {
            $('.ContractPanel').show();
        } else {
            $('.ContractPanel').hide();
        }
    }

    if (data.type === 'displayAll') {
        if (data.showUI) {
            document.getElementById('AllContracts').hidden = false;
        } else {
            document.getElementById('AllContracts').hidden = true;
        }
    }

    if (data.type === 'trialData') {
        document.getElementById('Heading').textContent = data.header;
    }

    if (data.type === 'contractData') {
        document.getElementById('time').textContent = data.time;
        document.getElementById('pay').textContent = data.pay;
        document.getElementById('name').textContent = data.name;
        document.getElementById('isPaid').hidden = true;
        document.getElementById('coord').hidden = true;
        document.getElementById('isPaid').textContent = data.isPaid;
        document.getElementById('coord').textContent = data.coord;
    }

    if (data.type === 'allContracts') {
        var divElement = document.getElementById('AllContracts');
        var allContractsHeader = document.createElement("div");
        allContractsHeader.innerHTML = `
        <center><h2>Security Contracts</h2></center>
        <center><button type="button" id="closeAll">Close</button></center>
        <hr>
        `;
        divElement.appendChild(allContractsHeader);
        data.contracts.forEach(contract => {
            var contractElement = document.createElement("div");
            contractElement.innerHTML = "Contract Name: " + contract.name + "<br>" + "Contract Time: " + contract.PatrolTime + " seconds" + "<br>" + "Contract Pay: $" + contract.Payout + "<hr>";
            divElement.appendChild(contractElement);
        });
        document.getElementById('closeAll').addEventListener('click', () => {
            axios.post(`https://${GetParentResourceName()}/closeAllContracts`, {});
            var divElement = document.getElementById('AllContracts');
            while (divElement.firstChild) {
                divElement.removeChild(divElement.firstChild);
              }
        });
    }
});

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('accept').addEventListener('click', () => {
        axios.post(`https://${GetParentResourceName()}/acceptContract`, {
            time: document.getElementById('time').textContent,
            pay: document.getElementById('pay').textContent,
            name: document.getElementById('name').textContent,
            isPaid: document.getElementById('isPaid').textContent,
            coord: document.getElementById('coord').textContent
        });
    });

    document.getElementById('decline').addEventListener('click', () => {
        axios.post(`https://${GetParentResourceName()}/declineContract`, {});
    });
}, false);