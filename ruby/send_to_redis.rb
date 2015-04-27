require "redis"
require "active_support"
require 'contracts'
include Contracts

module RedisService
  class XMLIndexer

    def initialize(params = {})
      @message = message(params)
      @queue   = "xml_index"
    end

    def send!
      redis = redis_client
      redis.multi do
        redis.sadd "queues", @queue
        redis.lpush "queue:#{@queue}", ActiveSupport::JSON.encode(@message)
      end
    end

    private
      def redis_client
        Redis.new
      end

      Contract ({ :ticket_id => Num, :xml_string => String, :company_rfc => String, :owner_rfc => String }) => HashOf[Symbol, Any]
      def message(message)
        message.merge({created_at: Time.now.to_i}) 
      end
  end
end

xml_string = <<XML
<?xml version="1.0" encoding="utf-8"?>
<cfdi:Comprobante xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sor="https://publicidad.soriana.com/xsd" xmlns:cfdi="http://www.sat.gob.mx/cfd/3"
  version="3.2"
  serie="BAGEI"
  folio="5785"
  fecha="2015-01-24T13:43:39"
  sello="ryRnE3LOUhEhsfwNTtzn9TsjUmKwFoZ0cOLQQrsu91K4p/ZH2ehtPdrQZgybjGvvqLO+pvdux5qjykcXSPVaYBbaXDau3KM3M8lRpTpxbnQELm1Quw0pygwFODGzzIwB/q2+gNlwGPRwkrFLGz7Q7LBf4wkltP6Q4mjZZv1UjeQ="
  formaDePago="El pago se hace en una sola exhibición."
  noCertificado="00001000000203239920"
  certificado="MIIEhTCCA22gAwIBAgIUMDAwMDEwMDAwMDAyMDMyMzk5MjAwDQYJKoZIhvcNAQEFBQAwggGVMTgwNgYDVQQDDC9BLkMuIGRlbCBTZXJ2aWNpbyBkZSBBZG1pbmlzdHJhY2nDs24gVHJpYnV0YXJpYTEvMC0GA1UECgwmU2VydmljaW8gZGUgQWRtaW5pc3RyYWNpw7NuIFRyaWJ1dGFyaWExODA2BgNVBAsML0FkbWluaXN0cmFjacOzbiBkZSBTZWd1cmlkYWQgZGUgbGEgSW5mb3JtYWNpw7NuMSEwHwYJKoZIhvcNAQkBFhJhc2lzbmV0QHNhdC5nb2IubXgxJjAkBgNVBAkMHUF2LiBIaWRhbGdvIDc3LCBDb2wuIEd1ZXJyZXJvMQ4wDAYDVQQRDAUwNjMwMDELMAkGA1UEBhMCTVgxGTAXBgNVBAgMEERpc3RyaXRvIEZlZGVyYWwxFDASBgNVBAcMC0N1YXVodMOpbW9jMRUwEwYDVQQtEwxTQVQ5NzA3MDFOTjMxPjA8BgkqhkiG9w0BCQIML1Jlc3BvbnNhYmxlOiBDZWNpbGlhIEd1aWxsZXJtaW5hIEdhcmPDrWEgR3VlcnJhMB4XDTEzMDMxMzIwNTE1OVoXDTE3MDMxMzIwNTE1OVowgcYxITAfBgNVBAMTGFRJRU5EQVMgU09SSUFOQSBTQSBERSBDVjEhMB8GA1UEKRMYVElFTkRBUyBTT1JJQU5BIFNBIERFIENWMSEwHwYDVQQKExhUSUVOREFTIFNPUklBTkEgU0EgREUgQ1YxJTAjBgNVBC0THFRTTzk5MTAyMlBCNiAvIEJFUFI1MzA1MDJSNzcxHjAcBgNVBAUTFSAvIEJFUFI1MzA1MDJIQ0xDTlkwMzEUMBIGA1UECxMLQ09SUE9SQVRJVk8wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAM7lgrKoPVZ5AemT9BjUubJqQtOsxZxBUn3/OVsR2b9E/nXaG4ej7/H8Iy6DZaPTdnsBDxnZjucsRMreOT0osvhob1TAKdgzSiio2yoc4/KPhwNHL0iRYhG+6UFeLZk6CxpSlkllncUmy/VtTiJPO4AabYz7uZ2oW8CdzhbaAzCxAgMBAAGjHTAbMAwGA1UdEwEB/wQCMAAwCwYDVR0PBAQDAgbAMA0GCSqGSIb3DQEBBQUAA4IBAQA63Kl7IwzqnqrWa4vxKpKOnbgN8XW5wajoLUJiPcZNBG6UZAKWmksoxJS6NC/T/0KMYaZvE3zvh2FrkMwcWJB03c0qHiolnPK+Inlv7Z6xzs65h/8WpP2cVpIKL7A/y6uTAEJ0QYFpqL7hiRqMr9GysFWnTFkh1WGCJexD5XI7AigSlGGF4Se8U0b07pu2kvMRiRBJCjvK/8030tpCyESwj+7PxNVpFmUsZXrC1kEHNdgmDC0N7ym1DkzlW2RCa9Qd3ego2xJDRIC90UNd4l+V9Qz0UqoZngJMQacgWsWrYJpA/2WJr+4d/27Ez0SeO8BtHEOcCXpXaWAwYj45L7Ji"
  subTotal="201.120000"
  descuento="0.000000"
  total="201.120000"
  tipoDeComprobante="ingreso"
  metodoDePago="No Identificado"
  LugarExpedicion="CIUDAD GENERAL ESCOBEDO, NUEVO LEON, MEXICO"
  MontoFolioFiscalOrig="0.000000"
  xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd https://publicidad.soriana.com/xsd https://publicidad.soriana.com/xsd/TS_B.xsd">
  <cfdi:Emisor
    rfc="TSO991022PB6"
    nombre="TIENDAS SORIANA, S.A. DE C.V.">
    <cfdi:DomicilioFiscal
      calle="ALEJANDRO DE RODAS"
      noExterior="3102"
      noInterior="A"
      colonia="CUMBRES 8VO SECTOR"
      localidad="MONTERREY"
      referencia="MONTERREY"
      municipio="MONTERREY"
      estado="NUEVO LEON"
      pais="MEXICO"
      codigoPostal="64610" />
    <cfdi:ExpedidoEn
      calle="AV. BENITO JUAREZ"
      colonia="PROLONGACION JUAREZ"
      municipio="CIUDAD GENERAL ESCOBEDO"
      estado="NUEVO LEON"
      pais="MEXICO"
      codigoPostal="66059" />
    <cfdi:RegimenFiscal
      Regimen="NO APLICA" />
  </cfdi:Emisor>
  <cfdi:Receptor
    rfc="SAAO780529E25"
    nombre="Omar Osvaldo Sanchez Alvarez">
    <cfdi:Domicilio
      calle="Rosario Castellanos"
      noExterior="109"
      colonia="LA CANTERA"
      municipio="GENERAL ESCOBEDO"
      estado="NUEVO LEON"
      pais="MEXICO"
      codigoPostal="66059" />
  </cfdi:Receptor>
  <cfdi:Conceptos>
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="CREMA NORTENITA LIQUIDA 250GR"
      valorUnitario="13.000000"
      importe="13.000000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="HUEVO BLANCO PAQ 12PZ ORESPI"
      valorUnitario="28.000000"
      importe="28.000000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="JUGO JUMEX FRESA/PLATANO MINIB"
      valorUnitario="4.400000"
      importe="4.400000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="JUGO JUMEX MANZANA MBK 200ML"
      valorUnitario="4.400000"
      importe="4.400000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="JUGO JUMEX NECTAR DURAZNO MBK"
      valorUnitario="4.400000"
      importe="4.400000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="JUGO JUMEX NECTAR MANGO MBK 20"
      valorUnitario="4.400000"
      importe="4.400000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="JUGO JUMEX NECTAR MANZANA MBK"
      valorUnitario="4.400000"
      importe="4.400000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="LECHE ULTRA SANTA CLARA ENTERA"
      valorUnitario="16.400000"
      importe="16.400000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="LECHE ULTRA SANTA CLARA LIGHT"
      valorUnitario="16.400000"
      importe="16.400000" />
    <cfdi:Concepto
      cantidad="0.310000"
      unidad="KILO"
      descripcion="LIMON AGRIO C/SEMILLA KG"
      valorUnitario="11.940000"
      importe="3.700000" />
    <cfdi:Concepto
      cantidad="1.090000"
      unidad="KILO"
      descripcion="MANZANA GOLDEN DELICIOUS KG"
      valorUnitario="41.900000"
      importe="45.670000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="PASTELITO MARINELA MI PINGINO"
      valorUnitario="23.500000"
      importe="23.500000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="QU PET SUI DANONINO MULTISA 25"
      valorUnitario="16.700000"
      importe="16.700000" />
    <cfdi:Concepto
      cantidad="1.000000"
      unidad="PIEZA"
      descripcion="TE MC CORMICK LIMON CJ 25SOB"
      valorUnitario="15.750000"
      importe="15.750000" />
  </cfdi:Conceptos>
  <cfdi:Impuestos
    totalImpuestosRetenidos="0.000000"
    totalImpuestosTrasladados="0.000000">
    <cfdi:Retenciones>
      <cfdi:Retencion
        impuesto="IVA"
        importe="0.000000" />
    </cfdi:Retenciones>
    <cfdi:Traslados>
      <cfdi:Traslado
        impuesto="IVA"
        tasa="0.000000"
        importe="0.000000" />
    </cfdi:Traslados>
  </cfdi:Impuestos>
  <cfdi:Complemento>
    <tfd:TimbreFiscalDigital xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      version="1.0"
      UUID="8202064B-1A29-445B-8433-C43EA9103D52"
      FechaTimbrado="2015-01-24T13:48:12"
      selloCFD="ryRnE3LOUhEhsfwNTtzn9TsjUmKwFoZ0cOLQQrsu91K4p/ZH2ehtPdrQZgybjGvvqLO+pvdux5qjykcXSPVaYBbaXDau3KM3M8lRpTpxbnQELm1Quw0pygwFODGzzIwB/q2+gNlwGPRwkrFLGz7Q7LBf4wkltP6Q4mjZZv1UjeQ="
      noCertificadoSAT="00001000000202639521"
      selloSAT="Fxx9PHOv0/CRZOT42cyvT06GrasDUJCWiVuMSJIdzY+DIYFEW79K6f5L7S3f/rKB6OHq9G8JIY0hHLOQk1ojFEOljLIBQ5alMCR2E1+PY3ZbUQUwoZK930/CW44NHWOr2siMdBfVyTZpzD5yAeAznhjlrOCgd9qZjX6AF7/DEo0="
      xsi:schemaLocation="http://www.sat.gob.mx/TimbreFiscalDigital http://www.sat.gob.mx/sitio_internet/TimbreFiscalDigital/TimbreFiscalDigital.xsd" xmlns:tfd="http://www.sat.gob.mx/TimbreFiscalDigital" />
  </cfdi:Complemento>
  <cfdi:Addenda>
    <sor:NewDataSet
      xsi:schemaLocation="https://publicidad.soriana.com/xsd https://publicidad.soriana.com/xsd/TS_B.xsd">
      <sor:ftFEEnc>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Cve_SerieFact>BAGEI</sor:Cve_SerieFact>
        <sor:Num_TipoFmtoFact>105</sor:Num_TipoFmtoFact>
        <sor:Fec_Fact>24/ENE/2015</sor:Fec_Fact>
        <sor:RFC_Emp>TSO991022PB6 </sor:RFC_Emp>
        <sor:Nom_Emp>TIENDAS SORIANA, S.A. DE C.V.</sor:Nom_Emp>
        <sor:Calle_Emp>ALEJANDRO DE RODAS</sor:Calle_Emp>
        <sor:Num_ExtEmp>3102</sor:Num_ExtEmp>
        <sor:Num_IntEmp>A</sor:Num_IntEmp>
        <sor:Colonia_Emp>CUMBRES 8 SECTOR</sor:Colonia_Emp>
        <sor:Num_CPEmp>64610</sor:Num_CPEmp>
        <sor:Nom_MpioEmp>MONTERREY</sor:Nom_MpioEmp>
        <sor:Nom_EdoEmp>NUEVO LEON</sor:Nom_EdoEmp>
        <sor:Nom_PaisEmp>MEXICO</sor:Nom_PaisEmp>
        <sor:RFC_Cte>SAAO780529E25</sor:RFC_Cte>
        <sor:Nom_Cte>Omar Osvaldo Sanchez Alvarez</sor:Nom_Cte>
        <sor:Calle_Cte>Rosario Castellanos</sor:Calle_Cte>
        <sor:Num_ExtCte>109</sor:Num_ExtCte>
        <sor:Num_IntCte />
        <sor:Colonia_Cte>LA CANTERA</sor:Colonia_Cte>
        <sor:Num_CPCte>66059</sor:Num_CPCte>
        <sor:Nom_MpioCte>GENERAL ESCOBEDO</sor:Nom_MpioCte>
        <sor:Nom_EdoCte>NUEVO LEON</sor:Nom_EdoCte>
        <sor:Nom_PaisCte>MEXICO</sor:Nom_PaisCte>
        <sor:Fol_HdaCte></sor:Fol_HdaCte>
        <sor:Fol_IEPSCte />
        <sor:Num_CtaCte />
        <sor:Nom_UN>CERRADAS DE ANAHUAC</sor:Nom_UN>
        <sor:Calle_UN>AV. BENITO JUAREZ</sor:Calle_UN>
        <sor:Num_ExtUN>508</sor:Num_ExtUN>
        <sor:Num_IntUN />
        <sor:Colonia_UN>PROLONGACION JUAREZ</sor:Colonia_UN>
        <sor:Num_CPUN>66059</sor:Num_CPUN>
        <sor:Nom_MpioUN>CIUDAD GENERAL ESCOBEDO</sor:Nom_MpioUN>
        <sor:Nom_EdoUN>NUEVO LEON</sor:Nom_EdoUN>
        <sor:Nom_PaisUN>MEXICO</sor:Nom_PaisUN>
        <sor:Imp_SubTotal>201.1200</sor:Imp_SubTotal>
        <sor:Imp_TotDctoEsp>0.0000</sor:Imp_TotDctoEsp>
        <sor:Imp_TotDctoPago>0.0000</sor:Imp_TotDctoPago>
        <sor:Imp_TotIVA>0.0000</sor:Imp_TotIVA>
        <sor:Imp_TotIEPS>0.0000</sor:Imp_TotIEPS>
        <sor:Imp_Total>201.1200</sor:Imp_Total>
        <sor:Imp_TotCmsnPago>0.0000</sor:Imp_TotCmsnPago>
        <sor:Imp_TotPago>201.1200</sor:Imp_TotPago>
        <sor:Fec_Vta>07/ENE/2015</sor:Fec_Vta>
        <sor:Cve_Ticket>06480107014200301023</sor:Cve_Ticket>
        <sor:Msg_PieFact01 />
        <sor:Msg_PieFact02 />
        <sor:Msg_PieFact03 />
        <sor:Msg_PieFact04 />
        <sor:Msg_PieFact05 />
        <sor:Msg_PieFact06 />
        <sor:Msg_PieFact07 />
        <sor:Msg_PieFact08 />
        <sor:Msg_PieFact09>El pago se hace en una sola exhibición.</sor:Msg_PieFact09>
        <sor:Msg_PieFact10>Venta del día: 07/ENE/2015, identificada con el Ticket No. 06480107014200301023.</sor:Msg_PieFact10>
        <sor:Cve_ServBco>CLAVE SERVICIO: 2503</sor:Cve_ServBco>
        <sor:Cve_CodBarRef>88000000020112064801070142003010231</sor:Cve_CodBarRef>
        <sor:Cve_RefBco>032015064801070142003010237</sor:Cve_RefBco>
        <sor:Desc_ImpLetra>Doscientos un Pesos 12/100 M.N.</sor:Desc_ImpLetra>
        <sor:Imp_TotIVARet>0.0000</sor:Imp_TotIVARet>
        <sor:Desc_FP>No Identificado</sor:Desc_FP>
        <sor:Cve_CtaFP />
        <sor:Desc_RegFiscal>NO APLICA</sor:Desc_RegFiscal>
      </sor:ftFEEnc>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>1</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>7501041204011 </sor:Cve_upc>
        <sor:Desc_upc>CREMA NORTENITA LIQUIDA 250GR</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     13.00</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     13.00</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>     13.00</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>2</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>7501388900010 </sor:Cve_upc>
        <sor:Desc_upc>HUEVO BLANCO PAQ 12PZ ORESPI</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     28.00</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     28.00</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>     28.00</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>3</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>75021436      </sor:Cve_upc>
        <sor:Desc_upc>JUGO JUMEX FRESA/PLATANO MINIB</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>      4.40</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>      4.40</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>      4.40</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>4</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>75010874      </sor:Cve_upc>
        <sor:Desc_upc>JUGO JUMEX MANZANA MBK 200ML</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>      4.40</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>      4.40</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>      4.40</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>5</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>75010935      </sor:Cve_upc>
        <sor:Desc_upc>JUGO JUMEX NECTAR DURAZNO MBK</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>      4.40</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>      4.40</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>      4.40</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>6</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>75010911      </sor:Cve_upc>
        <sor:Desc_upc>JUGO JUMEX NECTAR MANGO MBK 20</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>      4.40</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>      4.40</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>      4.40</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>7</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>75010928      </sor:Cve_upc>
        <sor:Desc_upc>JUGO JUMEX NECTAR MANZANA MBK</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>      4.40</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>      4.40</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>      4.40</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>8</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>7501295600126 </sor:Cve_upc>
        <sor:Desc_upc>LECHE ULTRA SANTA CLARA ENTERA</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     16.40</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     16.40</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>     16.40</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>9</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>7501295600140 </sor:Cve_upc>
        <sor:Desc_upc>LECHE ULTRA SANTA CLARA LIGHT</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     16.40</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     16.40</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>     16.40</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>10</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>3902          </sor:Cve_upc>
        <sor:Desc_upc>LIMON AGRIO C/SEMILLA KG</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     11.94</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     11.94</sor:Imp_PrecNeto>
        <sor:Cant_upc>     0.310</sor:Cant_upc>
        <sor:Imp_Totupc>      3.70</sor:Imp_Totupc>
        <sor:Desc_UniMed>KILO</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>11</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>4244          </sor:Cve_upc>
        <sor:Desc_upc>MANZANA GOLDEN DELICIOUS KG</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     41.90</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     41.90</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.090</sor:Cant_upc>
        <sor:Imp_Totupc>     45.67</sor:Imp_Totupc>
        <sor:Desc_UniMed>KILO</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>12</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>7501030484332 </sor:Cve_upc>
        <sor:Desc_upc>PASTELITO MARINELA MI PINGINO</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     23.50</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     23.50</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>     23.50</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>13</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>7501032395100 </sor:Cve_upc>
        <sor:Desc_upc>QU PET SUI DANONINO MULTISA 25</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     16.70</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     16.70</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>     16.70</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEDet>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>14</sor:Id_Num_Linea>
        <sor:Num_TipoLinea>1</sor:Num_TipoLinea>
        <sor:Cve_upc>7501003339355 </sor:Cve_upc>
        <sor:Desc_upc>TE MC CORMICK LIMON CJ 25SOB</sor:Desc_upc>
        <sor:Imp_TotIEPS />
        <sor:Imp_TotIVA />
        <sor:Imp_Precupc>     15.75</sor:Imp_Precupc>
        <sor:Imp_DctoEsp />
        <sor:Imp_Dcto />
        <sor:Imp_PrecNeto>     15.75</sor:Imp_PrecNeto>
        <sor:Cant_upc>     1.000</sor:Cant_upc>
        <sor:Imp_Totupc>     15.75</sor:Imp_Totupc>
        <sor:Desc_UniMed>PIEZA</sor:Desc_UniMed>
      </sor:ftFEDet>
      <sor:ftFEBaseImpto>
        <sor:Id_Num_UN>648</sor:Id_Num_UN>
        <sor:Id_Fol_Fact>5807</sor:Id_Fol_Fact>
        <sor:Id_Num_Linea>1</sor:Id_Num_Linea>
        <sor:Num_TipoImpto>2</sor:Num_TipoImpto>
        <sor:Desc_TipoImpto>IVA 0%</sor:Desc_TipoImpto>
        <sor:Imp_BaseImpto>201.1200</sor:Imp_BaseImpto>
        <sor:Imp_Impto>0.0000</sor:Imp_Impto>
        <sor:Porc_TasaImpto>0.00</sor:Porc_TasaImpto>
      </sor:ftFEBaseImpto>
    </sor:NewDataSet>
  </cfdi:Addenda>
</cfdi:Comprobante>
XML

RedisService::XMLIndexer.new({
  ticket_id: 101,
  xml_string: xml_string,
  company_rfc: "SORIANA",
  owner_rfc: "BAR"
}).send!
