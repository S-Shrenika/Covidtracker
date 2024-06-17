import UIKit

class CovidDataTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var positiveIncreaseLabel: UILabel!
    @IBOutlet weak var negativeIncreaseLabel: UILabel!
    @IBOutlet weak var deathIncreaseLabel: UILabel!
    @IBOutlet weak var hospitalizedIncreaseLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
