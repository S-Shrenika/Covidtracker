import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statePicker: UIPickerView!
    
    var covidData: [CovidData] = []
    var states: [State] = []
    var selectedState: State?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        statePicker.dataSource = self
        statePicker.delegate = self
        fetchStates()
    }
    
    func fetchStates() {
        StateDataFetcher.shared.fetchStates { states in
            if let states = states {
                self.states = states
                self.selectedState = states.first
                self.statePicker.reloadAllComponents()
                if let selectedState = self.selectedState {
                    self.fetchCovidData(for: selectedState.state)
                }
            }
        }
    }
    
    func fetchCovidData(for state: String) {
        CovidDataFetcher.shared.fetchCovidData(for: state) { data in
            if let data = data {
                self.covidData = data
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return covidData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CovidDataCell", for: indexPath) as? CovidDataTableViewCell else {
            return UITableViewCell()
        }
        
        let data = covidData[indexPath.row]
        cell.dateLabel.text = formattedDate(from: data.date)
        cell.positiveIncreaseLabel.text = "Positive Increase: \(data.positiveIncrease)"
        cell.negativeIncreaseLabel.text = "Negative Increase: \(data.negativeIncrease)"
        cell.deathIncreaseLabel.text = "Death Increase: \(data.deathIncrease)"
        cell.hospitalizedIncreaseLabel.text = "Hospitalized Increase: \(data.hospitalizedIncrease)"
        
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedState = states[row]
        if let selectedState = selectedState {
            fetchCovidData(for: selectedState.state)
        }
    }
    
    func formattedDate(from intDate: Int) -> String {
        let dateString = String(intDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return dateString
    }
}
