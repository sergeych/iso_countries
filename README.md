# IsoCountries

Gem provides country data according to ISO 3166 as OpenStruct object that
holds country name, number, A2 and A3 codes, and aliases if any. These objects
are global and shared, so you can add your own fields you might find useful.

Currently only few national names and aliases are added, you can add an issue
here https://github.com/sergeych/iso_countries/issues or just fork and add it
yourself.

## Installation

Add this line to your application's Gemfile:

    gem 'iso_countries'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iso_countries

## Usage


To get country data from name use either its ISO

    1.9.3-p327 :003 > require 'iso_countries'
     => true
    1.9.3-p327 :004 > IsoCountries.for_name 'Australia'
     => #<OpenStruct name="AUSTRALIA", code2="AU", code3="AUS", number=36>
    1.9.3-p327 :012 > IsoCountries.for_name 'United Kingdom'
     => #<OpenStruct name="UNITED KINGDOM", code2="GB", code3="GBR", number=826, name_aliases=["UNITED KINGDOM*", "Great Britain", "England"]>
    1.9.3-p327 :013 > 1.9.3-p327 :013 > IsoCountries.for_name 'Great Britain'
     => #<OpenStruct name="UNITED KINGDOM", code2="GB", code3="GBR", number=826, name_aliases=["UNITED KINGDOM*", "Great Britain", "England"]>

You can easily add your own alias:

    1.9.3-p327 :002 > IsoCountries.for_name('Oz') # No such country
     => nil

Add it with add_alias. First argument is 2 or 3-letter country code, then the desired name:

    1.9.3-p327 :003 > IsoCountries.add_alias 'AU', 'oz'
     => #<OpenStruct name="AUSTRALIA", code2="AU", code3="AUS", number=36, name_aliases=["oz"]>
    1.9.3-p327 :004 > IsoCountries.for_name('Oz')
     => #<OpenStruct name="AUSTRALIA", code2="AU", code3="AUS", number=36, name_aliases=["oz"]>
    1.9.3-p327 :005 >

To retrieve country information from its 2 or 3-letter code:

    1.9.3-p327 :005 > IsoCountries.for_code 'RUS'
     => #<OpenStruct name="RUSSIAN FEDERATION", code2="RU", code3="RUS", number=643, name_aliases=["Россия", "РФ", "Russia"]>
    1.9.3-p327 :006 > IsoCountries.for_code 'US'
     => #<OpenStruct name="UNITED STATES", code2="US", code3="USA", number=840, name_aliases=["USA", "США"]>
    1.9.3-p327 :006 > IsoCountries.for_code 'USA'
     => #<OpenStruct name="UNITED STATES", code2="US", code3="USA", number=840, name_aliases=["USA", "США"]>

###
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
