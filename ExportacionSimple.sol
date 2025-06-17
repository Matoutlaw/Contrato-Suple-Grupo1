// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ExportacionSimple {
    address public exportador;
    address public importador;
    uint public monto;
    bool public mercanciaEnviada;
    bool public mercanciaRecibida;

    string public nombreExportador = "BanenerAniloa S.A";
    string public nombreImportador = "ValenciA S.";
    string public producto = "Banano";
    string public paisOrigen = "Ecuador";
    string public paisDestino = "Peru";

    constructor(address _importador, uint _monto) {
        exportador = msg.sender;
        importador = _importador;
        monto = _monto;
        mercanciaEnviada = false;
        mercanciaRecibida = false;
    }

    // El exportador marca que la mercancía fue enviada
    function enviarMercancia() public {
        require(msg.sender == exportador, "Solo el exportador puede enviar la mercancia");
        mercanciaEnviada = true;
    }

    // El importador deposita el pago en el contrato
    function depositarPago() public payable {
        require(msg.sender == importador, "Solo el importador puede pagar");
        require(msg.value == monto, "El monto debe ser exacto");
        require(mercanciaEnviada, "La mercancia aun no ha sido enviada");
    }

    // El importador confirma la recepcion de la mercancia
    function confirmarRecepcion() public {
        require(msg.sender == importador, "Solo el importador puede confirmar");
        require(mercanciaEnviada, "La mercancia aun no ha sido enviada");
        mercanciaRecibida = true;
    }

    // El exportador retira el pago una vez confirmada la recepcion
    function retirarPago() public {
        require(msg.sender == exportador, "Solo el exportador puede retirar");
        require(mercanciaRecibida, "La mercancia no ha sido confirmada como recibida");
        payable(exportador).transfer(address(this).balance);
    }
}
