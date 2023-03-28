window.onload = function(){ 
    $('.ContractPanel').hide();
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