import { LightningElement,api,wire,track } from 'lwc';

import getInfo from "@salesforce/apex/APX_ValidateToAltaSAP.getInfo";
import SendWS from "@salesforce/apex/PAK_UpdateCustomerSAP.SendWS";
import updateAcc from "@salesforce/apex/APX_ValidateToAltaSAP.updateAcc";

export default class LWC_ValidateToAltaSAP extends LightningElement {
    @api recordId;
    AccObj;
    isUser;
    isReady;
    listToUpdate;
    altaResults;
    updateResults;

    @wire(getInfo,{RecordID: '$recordId'})
    getInfo({error,data}){
        if(data){
            console.log('entrando al metodo');
            var response= JSON.parse(JSON.stringify(data));
            this.isReady=response.isReady;
            this.isUser=response.isUser;
            if(response.isReady==true&&response.isUser==true){
                this.listToUpdate=true;
                SendWS({recordID: this.recordId})
                .then(result=>{this.altaResults=result})
                .catch(error=>this.altaResults=error)
                updateAcc({wrapp: data})
                .then(result2=>{this.updateResults=result2})
                .catch(error2=>this.altaResults=error2)
            }
        }else if(error){
            console.error('checar el siguiente error: ',error);
        }
    }
}