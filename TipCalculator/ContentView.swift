import SwiftUI

struct ContentView: View {
    
    @State private var enteredAmount: String = ""
    @State private var tipAmount: Double = 0
    @State private var totalAmount: Double = 0
    @State private var tipSlider: Double = 15
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Enter Bill Amount")
                    .foregroundColor(.secondary)
                TextField("0.00", text: $enteredAmount)
                    .font(.system(size: 70, weight: .semibold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .onChange(of: enteredAmount) { _ in
                        calculateTotals()
                    }
                
                Text("Tip : \(tipSlider, specifier: "%.0f")%")
                
                Slider(value: Binding(
                    get: {
                        self.tipSlider
                    },
                    set: { newValue in
                        if !self.enteredAmount.isEmpty {
                            self.tipSlider = newValue
                            self.calculateTotals()
                        } else {
                            self.showAlert = true
                        }
                    }
                ), in: 0...100, step: 1)
                
                VStack {
                    Text(tipAmount, format: .currency(code: "USD"))
                        .font(.title.bold())
                    
                    Text("Tip")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.top, 20)
                
                VStack {
                    Text(totalAmount, format: .currency(code: "USD"))
                        .font(.title.bold())
                    
                    Text("Total")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding(30)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please enter a bill amount before adjusting the tip percentage."), dismissButton: .default(Text("OK")))
            }
            .navigationBarItems(trailing:
                Group {
                    if totalAmount > 0 {
                        NavigationLink(destination: SplitBillView(totalAmount: $totalAmount)) {
                            Text("Split Bill")
                                .foregroundColor(.white)
                                .padding(5)
                                .background(.gray)
                                .cornerRadius(12)
                        }
                    }
                }
            )
        }
    }
    
    private func calculateTotals() {
        guard let amount = Double(enteredAmount) else {
            tipAmount = 0
            totalAmount = 0
            return
        }
        guard let tip = Calculation().calculateTip(of: amount, with: tipSlider) else {
            tipAmount = 0
            totalAmount = 0
            return
        }
        
        tipAmount = tip
        totalAmount = amount + tipAmount
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Calculation {
    func calculateTip(of enteredAmount: Double, with tip: Double) -> Double? {
        guard enteredAmount >= 0 && tip >= 0 else { return nil }
        let tipPercentage = tip / 100
        return enteredAmount * tipPercentage
    }
}

struct SplitBillView: View {
    @Binding var totalAmount: Double
    @State private var numberOfPeople: String = ""
    @State private var perPersonAmount: Double = 0
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Number of People")
                .foregroundColor(.secondary)
            TextField("0", text: $numberOfPeople)
                .font(.system(size: 40, weight: .semibold, design: .rounded))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .onChange(of: numberOfPeople) { _ in
                    calculatePerPersonAmount(totalAmount: totalAmount, numberOfPeople: numberOfPeople) { result, alert in
                        perPersonAmount = result
                        showAlert = alert
                    }
                }
            
            VStack {
                Text(perPersonAmount, format: .currency(code: "USD"))
                    .font(.title.bold())
                
                Text("Per Person")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(.top, 20)
        }
        .padding(30)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Please enter a valid number of people."), dismissButton: .default(Text("OK")))
        }
    }
    
    fileprivate func calculatePerPersonAmount(totalAmount: Double, numberOfPeople: String, completion: @escaping (Double, Bool) -> Void) {
        guard let people = Double(numberOfPeople), people > 0 else {
            completion(0, true)
            return
        }
        let perPerson = totalAmount / people
        completion(perPerson, false)
    }
}
struct SplitBillView_Previews: PreviewProvider {
    static var previews: some View {
        let totalAmount = Binding.constant(100.0) // Önizleme için bir totalAmount bağlamı oluşturuluyor
        return SplitBillView(totalAmount: totalAmount)
    }
}

struct BillCalculation {
    func calculatePerPersonAmount(totalAmount: Double, numberOfPeople: String, completion: @escaping (Double, Bool) -> Void) {
        guard let people = Double(numberOfPeople), people > 0 else {
            completion(0, true)
            return
        }
        let perPerson = totalAmount / people
        completion(perPerson, false)
    }
}
