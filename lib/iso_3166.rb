# encoding: utf-8
require "iso_3166/version"
require "unicode_utils/upcase"

module Iso3166

#
# Iso3166 countries standard utility class
# (C) 2010 Sergey S. Chernov, Trhift, RU
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

require 'ostruct'

	class Coder
	  class <<self
	    # Return ISO3166 data for a given country name, which is case insensitive
	    # but should correspond to this standard's names. There is no support for
	    # aliases or translations yet.
	    #
	    # @return [OpenStruct]
	    #
	    # An OpenStruct instance with preset fields: data.name,
	    # data.code2, data.code3 and data.number which corresponds to the
	    # respective standard's values e.g. Country, A 2, A 3, Number.
	    #
	    # You can add more fields to this object (as it is an OpenStruct), it will
	    # be shared between all calls of for_name and for_code, unless
	    # import_iso3166 will be called, what will effectively reset all data
	    # objects to default state.
	    #
	    # nil if there is no such country
	    #
	    def for_name name
	      @countries[UnicodeUtils.upcase name]
	    end

	    # Return ISO3166 data for a country code which could be of type 2 or 3, respectfully,
	    # 2 or 3 characters long, any case. For data format see Iso3166.for_name
	    def for_code code
	      code.length == 2 ? @codes2[code.upcase] : @codes3[code.upcase]
	    end

	    # Import country definitions file. The file format is as for Iso3166,
	    # see below. There is no need to call this method unless you want to override
	    # standard definitions in the file below.
	    #
	    # Note that it will redefine all country data objects so all user-added fields would be
	    # lost.
	    def import_iso3166 iso3166
	      rex        = /(.*?)\s+([A-Z]{2})\s+([A-Z]{3})\s+(\d+)/
	      @countries = { }
	      @codes2    = { }
	      @codes3    = { }
	      @numbers   = { }

	      iso3166.each_line { |s|
	        name, code2, code3, number = s.match(rex)[1..-1]
          name.strip!
	        data                       = OpenStruct.new name: name, code2: code2, code3: code3, number: number.to_i
	        @countries[UnicodeUtils.upcase name]    = data
	        @codes2[code2]             = data
	        @codes3[code3]             = data
	        @numbers[number]           = data
	      }
      end

      # Just like import, same data, create aliases if need for the same codes
      def import_aliases aliases
        aliases.each_line { |a|
          begin
            @@alias_rex ||= /(.*?)\s+([A-Z]{2})($|\s)/u
            name, code2 = a.match(@@alias_rex)[1..-1]
            name.strip!
            add_alias code2, name
          rescue
            puts "Can't process alias line: '#{a.chomp}'"
            raise
          end
        }
      end

      def add_alias code, name
        if (data = for_code(code)) && data.name != name
          data.name_aliases ||= []
          data.name_aliases << name
          @countries[UnicodeUtils.upcase name] = data
        end
      end

	    def to_objc
	      res = ["NSMutableDictionary* countries = @{"]
	      @countries.values.each { |c|
	        res << "    @\"#{c.code2}\" : @{ @\"name\" : @\"#{c.name}\", @\"code2\" : @\"#{c.code2}\", @\"code3\" : @\"#{c.code3}\" },"
	      }
	      res << "};"
	      res.join "\n"
	    end
	  end
	end


	# Return ISO3166 data for a country code which could be of type 2 or 3, respectfully,
	# 2 or 3 characters long, any case. For data format see Iso3166.for_name
	def for_code code
		Coder.for_code code
	end

	# Return ISO3166 data for a given country name, which is case insensitive
	# but should correspond to this standard's names. There is no support for
	# aliases or translations yet.
	#
	# @return [OpenStruct]
	#
	# An OpenStruct instance with preset fields: data.name,
	# data.code2, data.code3 and data.number which corresponds to the
	# respective standard's values e.g. Country, A 2, A 3, Number.
	#
	# You can add more fields to this object (as it is an OpenStruct), it will
	# be shared between all calls of for_name and for_code, unless
	# import_iso3166 will be called, what will effectively reset all data
	# objects to default state.
	#
	# nil if there is no such country
	#
	def for_name name
		Coder.for_name name
	end

  def add_alias code, name
    Coder.add_alias code, name
  end

	module_function :for_code, :for_name, :add_alias

end

	#
	# The countries definition is by intention 'plain', so you can easily update it
	# or provide your own from sources like http://userpage.chemie.fu-berlin.de/diverse/doc/ISO_3166.html
	#
	_iso3166 = <<-End
	AALAND ISLANDS                                  AX      ALA     248
	AFGHANISTAN                                     AF      AFG     004
	ALBANIA                                         AL      ALB     008
	ALGERIA                                         DZ      DZA     012
	AMERICAN SAMOA                                  AS      ASM     016
	ANDORRA                                         AD      AND     020
	ANGOLA                                          AO      AGO     024
	ANGUILLA                                        AI      AIA     660
	ANTARCTICA                                      AQ      ATA     010
	ANTIGUA AND BARBUDA                             AG      ATG     028
	ARGENTINA                                       AR      ARG     032
	ARMENIA                                         AM      ARM     051
	ARUBA                                           AW      ABW     533
	AUSTRALIA                                       AU      AUS     036
	AUSTRIA                                         AT      AUT     040
	AZERBAIJAN                                      AZ      AZE     031
	BAHAMAS                                         BS      BHS     044
	BAHRAIN                                         BH      BHR     048
	BANGLADESH                                      BD      BGD     050
	BARBADOS                                        BB      BRB     052
	BELARUS                                         BY      BLR     112
	BELGIUM                                         BE      BEL     056
	BELIZE                                          BZ      BLZ     084
	BENIN                                           BJ      BEN     204
	BERMUDA                                         BM      BMU     060
	BHUTAN                                          BT      BTN     064
	BOLIVIA                                         BO      BOL     068
	BOSNIA AND HERZEGOWINA                          BA      BIH     070
	BOTSWANA                                        BW      BWA     072
	BOUVET ISLAND                                   BV      BVT     074
	BRAZIL                                          BR      BRA     076
	BRITISH INDIAN OCEAN TERRITORY                  IO      IOT     086
	BRUNEI DARUSSALAM                               BN      BRN     096
	BULGARIA                                        BG      BGR     100
	BURKINA FASO                                    BF      BFA     854
	BURUNDI                                         BI      BDI     108
	CAMBODIA                                        KH      KHM     116
	CAMEROON                                        CM      CMR     120
	CANADA                                          CA      CAN     124
	CAPE VERDE                                      CV      CPV     132
	CAYMAN ISLANDS                                  KY      CYM     136
	CENTRAL AFRICAN REPUBLIC                        CF      CAF     140
	CHAD                                            TD      TCD     148
	CHILE                                           CL      CHL     152
	CHINA                                           CN      CHN     156
	CHRISTMAS ISLAND                                CX      CXR     162
	COCOS (KEELING) ISLANDS                         CC      CCK     166
	COLOMBIA                                        CO      COL     170
	COMOROS                                         KM      COM     174
	CONGO, Democratic Republic of (was Zaire)       CD      COD     180
	CONGO, Republic of                              CG      COG     178
	COOK ISLANDS                                    CK      COK     184
	COSTA RICA                                      CR      CRI     188
	COTE D'IVOIRE                                   CI      CIV     384
	CROATIA (local name: Hrvatska)                  HR      HRV     191
	CUBA                                            CU      CUB     192
	CYPRUS                                          CY      CYP     196
	CZECH REPUBLIC                                  CZ      CZE     203
	DENMARK                                         DK      DNK     208
	DJIBOUTI                                        DJ      DJI     262
	DOMINICA                                        DM      DMA     212
	DOMINICAN REPUBLIC                              DO      DOM     214
	ECUADOR                                         EC      ECU     218
	EGYPT                                           EG      EGY     818
	EL SALVADOR                                     SV      SLV     222
	EQUATORIAL GUINEA                               GQ      GNQ     226
	ERITREA                                         ER      ERI     232
	ESTONIA                                         EE      EST     233
	ETHIOPIA                                        ET      ETH     231
	FALKLAND ISLANDS (MALVINAS)                     FK      FLK     238
	FAROE ISLANDS                                   FO      FRO     234
	FIJI                                            FJ      FJI     242
	FINLAND                                         FI      FIN     246
	FRANCE                                          FR      FRA     250
	FRENCH GUIANA                                   GF      GUF     254
	FRENCH POLYNESIA                                PF      PYF     258
	FRENCH SOUTHERN TERRITORIES                     TF      ATF     260
	GABON                                           GA      GAB     266
	GAMBIA                                          GM      GMB     270
	GEORGIA                                         GE      GEO     268
	GERMANY                                         DE      DEU     276
	GHANA                                           GH      GHA     288
	GIBRALTAR                                       GI      GIB     292
	GREECE                                          GR      GRC     300
	GREENLAND                                       GL      GRL     304
	GRENADA                                         GD      GRD     308
	GUADELOUPE                                      GP      GLP     312
	GUAM                                            GU      GUM     316
	GUATEMALA                                       GT      GTM     320
	GUINEA                                          GN      GIN     324
	GUINEA-BISSAU                                   GW      GNB     624
	GUYANA                                          GY      GUY     328
	HAITI                                           HT      HTI     332
	HEARD AND MC DONALD ISLANDS                     HM      HMD     334
	HONDURAS                                        HN      HND     340
	HONG KONG                                       HK      HKG     344
	HUNGARY                                         HU      HUN     348
	ICELAND                                         IS      ISL     352
	INDIA                                           IN      IND     356
	INDONESIA                                       ID      IDN     360
	IRAN (ISLAMIC REPUBLIC OF)                      IR      IRN     364
	IRAQ                                            IQ      IRQ     368
	IRELAND                                         IE      IRL     372
	ISRAEL                                          IL      ISR     376
	ITALY                                           IT      ITA     380
	JAMAICA                                         JM      JAM     388
	JAPAN                                           JP      JPN     392
	JORDAN                                          JO      JOR     400
	KAZAKHSTAN                                      KZ      KAZ     398
	KENYA                                           KE      KEN     404
	KIRIBATI                                        KI      KIR     296
	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF          KP      PRK     408
	KOREA, REPUBLIC OF                              KR      KOR     410
	KUWAIT                                          KW      KWT     414
	KYRGYZSTAN                                      KG      KGZ     417
	LAO PEOPLE'S DEMOCRATIC REPUBLIC                LA      LAO     418
	LATVIA                                          LV      LVA     428
	LEBANON                                         LB      LBN     422
	LESOTHO                                         LS      LSO     426
	LIBERIA                                         LR      LBR     430
	LIBYAN ARAB JAMAHIRIYA                          LY      LBY     434
	LIECHTENSTEIN                                   LI      LIE     438
	LITHUANIA                                       LT      LTU     440
	LUXEMBOURG                                      LU      LUX     442
	MACAU                                           MO      MAC     446
	MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF      MK      MKD     807
	MADAGASCAR                                      MG      MDG     450
	MALAWI                                          MW      MWI     454
	MALAYSIA                                        MY      MYS     458
	MALDIVES                                        MV      MDV     462
	MALI                                            ML      MLI     466
	MALTA                                           MT      MLT     470
	MARSHALL ISLANDS                                MH      MHL     584
	MARTINIQUE                                      MQ      MTQ     474
	MAURITANIA                                      MR      MRT     478
	MAURITIUS                                       MU      MUS     480
	MAYOTTE                                         YT      MYT     175
	MEXICO                                          MX      MEX     484
	MICRONESIA, FEDERATED STATES OF                 FM      FSM     583
	MOLDOVA, REPUBLIC OF                            MD      MDA     498
	MONACO                                          MC      MCO     492
	MONGOLIA                                        MN      MNG     496
  MONTENEGRO                                      ME      MNE     499
	MONTSERRAT                                      MS      MSR     500
	MOROCCO                                         MA      MAR     504
	MOZAMBIQUE                                      MZ      MOZ     508
	MYANMAR                                         MM      MMR     104
	NAMIBIA                                         NA      NAM     516
	NAURU                                           NR      NRU     520
	NEPAL                                           NP      NPL     524
	NETHERLANDS                                     NL      NLD     528
	NETHERLANDS ANTILLES                            AN      ANT     530
	NEW CALEDONIA                                   NC      NCL     540
	NEW ZEALAND                                     NZ      NZL     554
	NICARAGUA                                       NI      NIC     558
	NIGER                                           NE      NER     562
	NIGERIA                                         NG      NGA     566
	NIUE                                            NU      NIU     570
	NORFOLK ISLAND                                  NF      NFK     574
	NORTHERN MARIANA ISLANDS                        MP      MNP     580
	NORWAY                                          NO      NOR     578
	OMAN                                            OM      OMN     512
	PAKISTAN                                        PK      PAK     586
	PALAU                                           PW      PLW     585
	PALESTINIAN TERRITORY, Occupied                 PS      PSE     275
	PANAMA                                          PA      PAN     591
	PAPUA NEW GUINEA                                PG      PNG     598
	PARAGUAY                                        PY      PRY     600
	PERU                                            PE      PER     604
	PHILIPPINES                                     PH      PHL     608
	PITCAIRN                                        PN      PCN     612
	POLAND                                          PL      POL     616
	PORTUGAL                                        PT      PRT     620
	PUERTO RICO                                     PR      PRI     630
	QATAR                                           QA      QAT     634
	REUNION                                         RE      REU     638
	ROMANIA                                         RO      ROU     642
	RUSSIAN FEDERATION                              RU      RUS     643
	RWANDA                                          RW      RWA     646
	SAINT HELENA                                    SH      SHN     654
	SAINT KITTS AND NEVIS                           KN      KNA     659
	SAINT LUCIA                                     LC      LCA     662
	SAINT PIERRE AND MIQUELON                       PM      SPM     666
	SAINT VINCENT AND THE GRENADINES                VC      VCT     670
	SAMOA                                           WS      WSM     882
	SAN MARINO                                      SM      SMR     674
	SAO TOME AND PRINCIPE                           ST      STP     678
	SAUDI ARABIA                                    SA      SAU     682
	SENEGAL                                         SN      SEN     686
  SERBIA                                          RS      SRB     688
	SEYCHELLES                                      SC      SYC     690
	SIERRA LEONE                                    SL      SLE     694
	SINGAPORE                                       SG      SGP     702
	SLOVAKIA                                        SK      SVK     703
	SLOVENIA                                        SI      SVN     705
	SOLOMON ISLANDS                                 SB      SLB     090
	SOMALIA                                         SO      SOM     706
	SOUTH AFRICA                                    ZA      ZAF     710
	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS    GS      SGS     239
	SPAIN                                           ES      ESP     724
	SRI LANKA                                       LK      LKA     144
	SUDAN                                           SD      SDN     736
	SURINAME                                        SR      SUR     740
	SVALBARD AND JAN MAYEN ISLANDS                  SJ      SJM     744
	SWAZILAND                                       SZ      SWZ     748
	SWEDEN                                          SE      SWE     752
	SWITZERLAND                                     CH      CHE     756
	SYRIAN ARAB REPUBLIC                            SY      SYR     760
	TAIWAN                                          TW      TWN     158
	TAJIKISTAN                                      TJ      TJK     762
	TANZANIA, UNITED REPUBLIC OF                    TZ      TZA     834
	THAILAND                                        TH      THA     764
	TIMOR-LESTE                                     TL      TLS     626
	TOGO                                            TG      TGO     768
	TOKELAU                                         TK      TKL     772
	TONGA                                           TO      TON     776
	TRINIDAD AND TOBAGO                             TT      TTO     780
	TUNISIA                                         TN      TUN     788
	TURKEY                                          TR      TUR     792
	TURKMENISTAN                                    TM      TKM     795
	TURKS AND CAICOS ISLANDS                        TC      TCA     796
	TUVALU                                          TV      TUV     798
	UGANDA                                          UG      UGA     800
	UKRAINE                                         UA      UKR     804
	UNITED ARAB EMIRATES                            AE      ARE     784
	UNITED KINGDOM                                  GB      GBR     826
	UNITED STATES                                   US      USA     840
	UNITED STATES MINOR OUTLYING ISLANDS            UM      UMI     581
	URUGUAY                                         UY      URY     858
	UZBEKISTAN                                      UZ      UZB     860
	VANUATU                                         VU      VUT     548
	VATICAN CITY STATE (HOLY SEE)                   VA      VAT     336
	VENEZUELA                                       VE      VEN     862
	VIET NAM                                        VN      VNM     704
	VIRGIN ISLANDS (BRITISH)                        VG      VGB     092
	VIRGIN ISLANDS (U.S.)                           VI      VIR     850
	WALLIS AND FUTUNA ISLANDS                       WF      WLF     876
	WESTERN SAHARA                                  EH      ESH     732
	YEMEN                                           YE      YEM     887
	ZAMBIA                                          ZM      ZMB     894
	ZIMBABWE                                        ZW      ZWE     716
End

_aliases = <<End
ÅLAND ISLANDS 					AX 	ALA 	248
AFGHANISTAN 					AF 	AFG 	004
ALBANIA 					AL 	ALB 	008
ALGERIA 					DZ 	DZA 	012
AMERICAN SAMOA 					AS 	ASM 	016
ANDORRA 					AD 	AND 	020
ANGOLA 						AO 	AGO 	024
ANGUILLA 					AI 	AIA 	660
ANTARCTICA 					AQ 	ATA 	010
ANTIGUA AND BARBUDA 				AG 	ATG 	028
ARGENTINA 					AR 	ARG 	032
ARMENIA 					AM 	ARM 	051
ARUBA 						AW 	ABW 	553
AUSTRALIA 					AU 	AUS 	036
AUSTRIA 					AT 	AUT 	040
AZERBAIJAN 					AZ 	AZE 	031
BAHAMAS 					BS 	BHS 	044
BAHRAIN 					BH 	BHR 	048
BANGLADESH 					BD 	BGD 	050
BARBADOS 					BB 	BRB 	052
BELARUS 					BY 	BLR 	112
BELGIUM 					BE 	BEL 	056
BELIZE 						BZ 	BLZ 	084
BENIN 						BJ 	BEN 	204
BERMUDA 					BM 	BMU 	060
BHUTAN 						BT 	BTN 	064
BOLIVIA, PLURINATIONAL STATE OF 		BO 	BOL 	068
BONAIRE, SINT EUSTATIUS AND SABA 		BQ 	BES 	535
BOSNIA AND HERZEGOWINA 				BA 	BIH 	070
BOTSWANA 					BW 	BWA 	072
BOUVET ISLAND 					BV 	BVT 	074
BRAZIL 						BR 	BRA 	076
BRITISH INDIAN OCEAN TERRITORY 			IO 	IOT 	086
BRUNEI DARUSSALAM		 		BN 	BRN 	096
BULGARIA 					BG 	BGR 	100
BURKINA FASO 					BF 	BFA 	854
BURUNDI 					BI 	BDI 	108
CAMBODIA 					KH 	KHM 	116
CAMEROON 					CM 	CMR 	120
CANADA 						CA 	CAN 	124
CAPE VERDE 					CV 	CPV 	132
CAYMAN ISLANDS 					KY 	CYM 	136
CENTRAL AFRICAN REPUBLIC 			CF 	CAF 	140
CHAD 						TD 	TCD 	148
CHILE 						CL 	CHL 	152
CHINA 						CN 	CHN 	156
CHRISTMAS ISLAND		 		CX 	CXR 	162
COCOS (KEELING) ISLANDS 			CC 	CCK 	166
COLOMBIA 					CO 	COL 	170
COMOROS 					KM 	COM 	174
CONGO 						CG 	COG 	178
CONGO, THE DEMOCRATIC REPUBLIC OF THE 		CD 	COD 	180
COOK ISLANDS 					CK 	COK 	184
COSTA RICA 					CR 	CRI 	188
COTE D'IVOIRE 					CI 	CIV 	384
CROATIA (local name Hrvatska) 			HR 	HRV 	191
CUBA 						CU 	CUB 	192
CURAÇAO 					CW 	CUW 	531
CYPRUS 						CY 	CYP 	196
CZECH REPUBLIC 					CZ 	CZE 	203
DENMARK 					DK 	DNK 	208
DJIBOUTI 					DJ 	DJI 	262
DOMINICA 					DM 	DMA 	212
DOMINICAN REPUBLIC		 		DO 	DOM 	214
ECUADOR 					EC 	ECU 	218
EGYPT 						EG 	EGY 	818
EL SALVADOR 					SV 	SLV 	222
EQUATORIAL GUINEA 				GQ 	GNQ 	226
ERITREA 					ER 	ERI 	232
ESTONIA 					EE 	EST 	233
ETHIOPIA 					ET 	ETH 	231
FALKLAND ISLANDS (MALVINAS) 			FK 	FLK 	238
FAROE ISLANDS 					FO 	FRO 	234
FIJI 						FJ 	FJI 	242
FINLAND 					FI 	FIN 	246
FRANCE 						FR 	FRA 	250
FRENCH GUIANA 					GF 	GUF 	254
FRENCH POLYNESIA 				PF 	PYF 	258
FRENCH SOUTHERN TERRITORIES 			TF 	ATF 	260
GABON 						GA 	GAB 	266
GAMBIA 						GM 	GMB 	270
GEORGIA 					GE 	GEO 	268
GERMANY 					DE 	DEU 	276
GHANA 						GH 	GHA 	288
GIBRALTAR 					GI 	GIB 	292
GREECE 						GR 	GRC 	300
GREENLAND 					GL 	GRL 	304
GRENADA 					GD 	GRD 	308
GUADELOUPE 					GP 	GLP 	312
GUAM 						GU 	GUM 	316
GUATEMALA			 		GT 	GTM 	320
GUERNSEY 					GG 	GGY 	831
GUINEA 						GN 	GIN 	324
GUINEA-BISSAU 					GW 	GNB 	624
GUYANA 						GY 	GUY 	328
HAITI 						HT 	HTI 	332
HEARD AND MC DONALD ISLANDS 			HM 	HMD 	334
HOLY SEE (VATICAN CITY STATE) 			VA 	VAT 	336
HONDURAS 					HN 	HND 	340
HONG KONG 					HK 	HKG 	344
HUNGARY 					HU 	HUN 	348
ICELAND 					IS 	ISL 	352
INDIA 						IN 	IND 	356
INDONESIA 					ID 	IDN 	360
IRAN (ISLAMIC REPUBLIC OF) 			IR 	IRN 	364
IRAQ 						IQ 	IRQ 	368
IRELAND 					IE 	IRL 	372
ISLE OF MAN 					IM 	IMN 	833
ISRAEL 						IL 	ISR 	376
ITALY 						IT 	ITA 	380
JAMAICA 					JM 	JAM 	388
JAPAN 						JP 	JPN 	392
JERSEY 						JE 	JEY 	832
JORDAN 						JO 	JOR 	400
KAZAKHSTAN 					KZ 	KAZ 	398
KENYA				 		KE 	KEN 	404
KIRIBATI 					KI 	KIR 	296
KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF 		KP 	PRK 	408
KOREA, REPUBLIC OF		 		KR 	KOR 	410
KUWAIT 						KW 	KWT 	414
KYRGYZSTAN 					KG 	KGZ 	417
LAO PEOPLE'S DEMOCRATIC REPUBLIC 		LA 	LAO 	418
LATVIA 						LV 	LVA 	428
LEBANON 					LB 	LBN 	422
LESOTHO 					LS 	LSO 	426
LIBERIA 					LR 	LBR 	430
LIBYA						LY 	LBY 	434
LIECHTENSTEIN 					LI 	LIE 	438
LITHUANIA 					LT 	LTU 	440
LUXEMBOURG 					LU 	LUX 	442
MACAO 						MO 	MAC 	446
MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF 	MK 	MKD 	807
MADAGASCAR 					MG 	MDG 	450
MALAWI 						MW 	MWI 	454
MALAYSIA 					MY 	MYS 	458
MALDIVES 					MV 	MDV 	462
MALI 						ML 	MLI 	466
MALTA 						MT 	MLT 	470
MARSHALL ISLANDS 				MH 	MHL 	485
MARTINIQUE 					MQ 	MTQ 	474
MAURITANIA 					MR 	MRT 	478
MAURITIUS 					MU 	MUS 	480
MAYOTTE 					YT 	MYT 	175
MEXICO 						MX 	MEX 	484
MICRONESIA, FEDERATED STATES OF		 	FM 	FSM 	583
MOLDOVA, REPUBLIC OF 				MD 	MDA 	498
MONACO 						MC 	MCO 	492
MONGOLIA 					MN 	MNG 	496
MONTENEGRO 					ME 	MNE 	499
MONTSERRAT 					MS 	MSR 	500
MOROCCO 					MA 	MAR 	504
MOZAMBIQUE 					MZ 	MOZ 	508
MYANMAR 					MM 	MMR 	104
NAMIBIA 					NA 	NAM 	516
NAURU 						NR 	NRU 	520
NEPAL 						NP 	NPL 	524
NETHERLANDS 					NL 	NLD 	528
NEW CALEDONIA 					NC 	NCL 	540
NEW ZEALAND 					NZ 	NZL 	554
NICARAGUA 					NI 	NIC 	558
NIGER 						NE 	NER 	562
NIGERIA 					NG 	NGA 	566
NIUE 						NU 	NIU 	570
NORFOLK ISLAND 					NF 	NFK 	574
NORTHERN MARIANA ISLANDS 			MP 	MNP 	580
NORWAY 						NO 	NOR 	578
OMAN 						OM 	OMN 	512
PAKISTAN 					PK 	PAK 	586
PALAU 						PW 	PLW 	585
PALESTINIAN TERRITORY, OCCUPIED 		PS 	PSE 	275
PANAMA 						PA 	PAN 	591
PAPUA NEW GUINEA 				PG 	PNG 	598
PARAGUAY 					PY 	PRY 	600
PERU 						PE 	PER 	604
PHILIPPINES 					PH 	PHL 	608
PITCAIRN 					PN 	PCN 	612
POLAND 						PL 	POL 	616
PORTUGAL 					PT 	PRT 	620
PUERTO RICO 					PR 	PRI 	630
QATAR 						QA 	QAT 	634
REUNION 					RE 	REU 	638
ROMANIA 					RO 	ROU 	642
RUSSIAN FEDERATION 				RU 	RUS 	643
RWANDA 						RW 	RWA 	646
SAINT HELENA, ASCENSION AND TRISTAN DA CUNHA    SH      SHN     654
SAINT BARTHÉLEMY				BL	BLM	652
SAINT KITTS AND NEVIS 				KN 	KNA 	659
SAINT LUCIA 					LC 	LCA 	662
SAINT PIERRE AND MIQUELON                       PM      SPM     666
SAINT VINCENT AND THE GRENADINES 		VC 	VCT 	670
SAMOA 						WS 	WSM 	882
SAN MARINO 					SM 	SMR 	674
SAO TOME AND PRINCIPE 				ST 	STP 	678
SAUDI ARABIA 					SA 	SAU 	682
SENEGAL 					SN 	SEN 	686
SERBIA 						RS 	SRB 	688
SEYCHELLES 					SC 	SYC 	690
SIERRA LEONE 					SL 	SLE 	694
SINGAPORE 					SG 	SGP 	702
SINT MAARTEN (DUTCH PART) 			SX 	SXM 	534
SLOVAKIA 					SK 	SVK 	703
SLOVENIA 					SI 	SVN 	705
SOLOMON ISLANDS 				SB 	SLB 	090
SOMALIA 					SO 	SOM 	706
SOUTH AFRICA 					ZA 	ZAF 	710
SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS 	GS 	SGS 	239
SOUTH SUDAN 					SS 	SSD 	728
SPAIN 						ES 	ESP 	724
SRI LANKA 					LK 	LKA 	144
SUDAN 						SD 	SDN 	729
SURINAME 					SR 	SUR 	740
SVALBARD AND JAN MAYEN ISLANDS 			SJ 	SJM 	744
SWAZILAND 					SZ 	SWZ 	748
SWEDEN 						SE 	SWE 	752
SWITZERLAND 					CH 	CHE 	756
SYRIAN ARAB REPUBLIC 				SY 	SYR 	760
TAIWAN, PROVINCE OF CHINA 			TW 	TWN 	158
TAJIKISTAN 					TJ 	TJK 	762
TANZANIA, UNITED REPUBLIC OF 			TZ 	TZA 	834
THAILAND 					TH 	THA 	764
TIMOR-LESTE 					TL 	TLS 	626
TOGO 						TG 	TGO 	768
TOKELAU 					TK 	TKL 	772
TONGA 						TO 	TON 	776
TRINIDAD AND TOBAGO 				TT 	TTO 	780
TUNISIA 					TN 	TUN 	788
TURKEY 						TR 	TUR 	792
TURKMENISTAN 					TM 	TKM 	795
TURKS AND CAICOS ISLANDS 			TC 	TCA 	796
TUVALU 						TV 	TUV 	798
UGANDA 						UG 	UGA 	800
UKRAINE 					UA 	UKR 	804
UNITED ARAB EMIRATES 				AE 	ARE 	784
UNITED KINGDOM* 				GB 	GBR 	826
UNITED STATES 					US 	USA 	840
UNITED STATES MINOR OUTLYING ISLANDS 		UM 	UMI 	581
URUGUAY 					UY 	URY 	858
UZBEKISTAN 					UZ 	UZB 	860
VANUATU 					VU 	VUT 	548
VENEZUELA, BOLIVARIAN REPUBLIC OF 		VE 	VEN 	862
VIET NAM 					VN 	VNM 	704
VIRGIN ISLANDS (BRITISH) 			VG 	VGB 	092
VIRGIN ISLANDS (U.S.) 				VI 	VIR 	850
WALLIS AND FUTUNA ISLANDS 			WF 	WLF 	876
WESTERN SAHARA 					EH 	ESH 	732
YEMEN 						YE 	YEM 	887
ZAMBIA 						ZM 	ZMB 	894
ZIMBABWE 					ZW 	ZWE 	716
End

_more_aliases = <<End
USA           US
США           US
Россия        RU
РФ            RU
Russia        RU
Great Britain GB
England       GB
End


# By default, initialize with contents above
Iso3166::Coder.import_iso3166 _iso3166
Iso3166::Coder.import_aliases _aliases
Iso3166::Coder.import_aliases _more_aliases



