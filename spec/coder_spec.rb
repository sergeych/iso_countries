# encoding: utf-8
require 'iso_countries'

describe IsoCountries do
  it 'should return valid data' do
    data = IsoCountries.for_name('UNIted STATES MINOR OUTLYING ISLANDs')
    data.should_not be_nil
    data.name.should == 'UNITED STATES MINOR OUTLYING ISLANDS'
    data.code2.should == 'UM'
    data.code3.should == 'UMI'
    data.number.should == 581

    #SWEDEN                                          SE      SWE     752
    data = IsoCountries.for_code 'SE'
    data.name.should == 'SWEDEN'
    data.code2.should == 'SE'
    data.code3.should == 'SWE'
    data.number.should == 752

    data = IsoCountries.for_code 'SWE'
    data.name.should == 'SWEDEN'
    data.code2.should == 'SE'
    data.code3.should == 'SWE'
    data.number.should == 752
  end

  it 'should detect aliases' do
    IsoCountries.for_name('USA').code2.should == 'US'
    IsoCountries.for_name('США').code2.should == 'US'
    IsoCountries.for_name('Россия').code3.should == 'RUS'
    IsoCountries.for_name('РОСсия').code3.should == 'RUS'
    IsoCountries.for_name('russia').code3.should == 'RUS'
    IsoCountries.for_name('england').code2.should == 'GB'
  end

  it 'should add aliases' do
    IsoCountries.add_alias 'AU', 'Oz'
    IsoCountries.for_name('OZ').code2.should == 'AU'
  end
end
