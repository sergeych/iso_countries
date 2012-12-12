# encoding: utf-8
require 'iso_3166'

describe Iso3166 do
  it 'should return valid data' do
    data = Iso3166.for_name('UNIted STATES MINOR OUTLYING ISLANDs')
    data.should_not be_nil
    data.name.should == 'UNITED STATES MINOR OUTLYING ISLANDS'
    data.code2.should == 'UM'
    data.code3.should == 'UMI'
    data.number.should == 581

    #SWEDEN                                          SE      SWE     752
    data = Iso3166.for_code 'SE'
    data.name.should == 'SWEDEN'
    data.code2.should == 'SE'
    data.code3.should == 'SWE'
    data.number.should == 752

    data = Iso3166.for_code 'SWE'
    data.name.should == 'SWEDEN'
    data.code2.should == 'SE'
    data.code3.should == 'SWE'
    data.number.should == 752
  end

  it 'should detect aliases' do
    Iso3166.for_name('USA').code2.should == 'US'
    Iso3166.for_name('США').code2.should == 'US'
    Iso3166.for_name('Россия').code3.should == 'RUS'
    Iso3166.for_name('РОСсия').code3.should == 'RUS'
    Iso3166.for_name('russia').code3.should == 'RUS'
    Iso3166.for_name('england').code2.should == 'GB'
  end

  it 'should add aliases' do
    Iso3166.add_alias 'AU', 'Oz'
    Iso3166.for_name('OZ').code2.should == 'AU'
  end
end
