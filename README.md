Ruby Version: 3.0.0 - Rails Version: 6.1.4.1

# Social Media Status API Takehome

Social Media Status API Takehome is a take home exam with the goal of fetching data from the root path '/' of a server. Then that server fetches data from 3 endpoints which returns their data in the form of { twitter: [tweets], facebook: [statuses], instagram: [photos] }

## Installation

Clone the repository with ```git clone https://github.com/SolomonRFeldman/social-media-status-api-takehome.git``` then ```cd social-media-status-api-takehome```. Run ```$ bundle install``` to install the relevant gems. Finally run ```$ rails s``` to run the server locally in development mode and ```curl localhost:3000``` to see the final results.

## Tests

Running ```rspec``` will run all relevent specs, being service and features specs.