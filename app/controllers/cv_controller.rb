class CvController < ApplicationController
  def index
    @no_banner = true
    @works = []
    @works.push({'title': 'Static web page Game', 'duration': '2015.3 - 2015.6', 'description': 'Using <strong>HTML</strong> and <strong>JavaScript</strong> to make a static web page RPG game engine and extendable game.'})
    @works.push({'title': 'IOS Music Beats Player', 'duration': '2015.6 - 2015.8', 'description': 'A toy app developed in <strong>team work</strong> for Chins-US Maker Competition, which could play music in beats and equipped simple but beautiful UI.'})
    @works.push({'title': 'Android Develope', 'duration': '2016.3 - 2016.5', 'description': 'An academic experiment for testing <strong>OpenGL ES</strong> on Android using Wi-Fi connenting, and making multi devices to work together.'})
    #@works.push({'title': 'Online File Manage Server', 'duration': '2016.8 - 2016.11', 'description': 'Develope a online web server managing users and file uploading with <strong>Ruby on Rails</strong>.'})
    @works.push({'title': 'Web service testing', 'duration': '2017.4 - 2017.6', 'description': 'Writing script to test server page in university for course experiment, founding some vulnerabilities including XSS injection, authentication fault, and privilege control problem.'})
    @works.push({'title': 'Web BBS Service', 'duration': '2017.6 - Present', 'description': 'Design and develope a web BBS with <strong>Ruby on Rails</strong> on my own, which now has basic functions, has been deployed on Ali Cloud Server for testing.'})
    @works.push({'title': 'Intern for Sense Time', 'duration': '2017.7 - 2017.10', 'description': 'Working as an intern for <strong>Sense Time</strong>, and learning run <strong>Apache Strom</strong>.'})

    @works = @works.reverse

    @skills = []
    @skills.push({'name': 'Basic program', 'content': 'Pyhton, Java, C++, Objective-C, Ruby'})
    @skills.push({'name': 'Web', 'content': 'HTML, JavaScript, CSS, Ajax, JQuery, CoffeeScript'})
    @skills.push({'name': 'Web Application', 'content': 'Ruby on Rails, Django'})
    @skills.push({'name': 'Mobile Application', 'content': 'IOS, Android'})
    @skills.push({'name': 'Platform', 'content': 'Linux, Mac OS'})
    @skills.push({'name': 'Others', 'content': 'Linux shell, Vim, Shell script, Git'})
    @skills.push({'name': 'Language', 'content': 'Chinese, English, Japanese'})

  end
end
