

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let tweetCount = 100
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    
    let swifter = Swifter(consumerKey: "qK7YQx4BE3QQvJkiJry4jMXqi", consumerSecret: "wgQmdV815CFOqxrSraMSuCvkPU0PtNUuNhar6IP9ElfbIYYSr4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
    
    
    }
    
    
    func fetchTweets(){
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results,  metadata) in
      
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount{
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }

                
                self.makePredictions(with: tweets)
            
                
            }) { error in
                print("Error with an Twitter API error, \(error)")
            }
            
            
        }
    }
    
    func makePredictions(with tweets: [TweetSentimentClassifierInput]){
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            
            
            var sentimentScore = 0
            
            for prediction in predictions {
                let sentiment = prediction.label
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            
            updateUI(with: sentimentScore)
            

            
        } catch {
            print("error")
        }
    }
    
    func updateUI(with sentimentScore: Int){
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😃"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "🫤"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
    
}

