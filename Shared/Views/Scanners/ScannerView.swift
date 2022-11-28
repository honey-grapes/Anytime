//
//  AddContactScannerView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/21/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct ScannerView: View {
    @Binding var openScanner: Bool
    @Binding var scanResult: String
    @State private var reScanAlert: Bool = false
    @State private var reScanAlertMsg: String = ""
    @Environment(\.dismiss) private var dismiss
    
    @Binding var lastName: String
    @Binding var firstName: String
    @Binding var phoneNumber: String
    
    var body: some View {
        VStack(alignment: .center){
            //Instruction
            VStack(alignment: .leading){
                (Text("⚠️  請在明亮處將相機對準聯絡人資料，看到字字清晰，周圍出現")+(Text("黃色框框")+Text(Image(systemName: "square.dashed"))).bold().foregroundColor(Color("Yellow Box"))+Text("後，") + Text("按下").bold() + (Text("黃色框框")+Text(Image(systemName: "square.dashed"))).bold().foregroundColor(Color("Yellow Box")) + Text("讀取資料"))
                    .font(.system(size: 20))
                    .frame(alignment: .center)
                    .lineSpacing(5)
                
                ScannerViewController(openScanner: $openScanner, scanResult: $scanResult)
                    .cornerRadius(20)
            }
            .padding()
            
            //Instruction and scanned information preview
            VStack (alignment: .center, spacing: 5) {
                (Text("如果以下資料") + Text("正確").bold().foregroundColor(Color("Confirm")) + Text("，請按確定"))
                    .font(.system(size: 20))
                (Text("如果以下資料") + Text("不正確").bold().foregroundColor(Color("Cancel")) + Text("，請重按黃框框"))
                    .font(.system(size: 20))
                
                VStack{
                    Text((scanResult == "") ? "\n⌛️ 等待讀取...\n" : scanResult)
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .padding()
                        .foregroundColor(Color("Primary"))
                        .background(Color("Background"))
                        .cornerRadius(20)
                }
                .padding([.top,.leading,.trailing],20)
                
                VStack{
                    //Parse the scan result and update the last name, first name, and phone number fields
                    Button{
                        //Break scanResult into an array
                        let scanArr = scanResult.components(separatedBy: CharacterSet(charactersIn: "\n"))
                        
                        //Make sure the length is 3 and, given that, the phone number does not contain any alphabets
                        if (scanArr.count != 3) {
                            reScanAlert = true
                            reScanAlertMsg = "⚠️ 讀取資料超過三行（請重寫或重新拍照）"
                            scanResult = ""
                        }
                        else if (!CharacterSet(charactersIn: scanArr[2]).isSubset(of: CharacterSet.decimalDigits)) {
                            reScanAlert = true
                            reScanAlertMsg = "⚠️ 號碼只能有數字（請重寫或重新拍照）"
                            scanResult = ""
                        }
                        else{
                            lastName = scanArr[0]
                            firstName = scanArr[1]
                            phoneNumber = scanArr[2]
                            self.dismiss()
                        }
                    }
                    label: {
                        GenericButton(buttonText: "確定", bgColor: Color("Confirm"), fgColor: Color("Button Text"), height:50, fontSize:20, curve: 15)
                    }
                    .alert(reScanAlertMsg, isPresented: $reScanAlert){
                        Button("OK", role: .cancel) {}
                    }
                     
                    //Cancel and clear result
                    Button{
                        scanResult = ""
                        self.dismiss()
                    }
                    label: {
                        GenericButton(buttonText: "取消重來", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height:50, fontSize:20, curve: 15)
                    }
                }
                .padding(20)
            }
        }
        .padding(20)
        .foregroundColor(Color("Primary"))
    }
}

@available(iOS 16.0, *)
struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(openScanner: .constant(true), scanResult: .constant(""), lastName: .constant(""), firstName: .constant(""), phoneNumber: .constant(""))
    }
}
