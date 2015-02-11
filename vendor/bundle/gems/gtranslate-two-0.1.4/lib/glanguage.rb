module GLanguage
  
  Afrikaans	= 'af'
  Albanian = 'sq'
  Arabic = 'ar'
  Belarusian = 'be'
  Bulgarian	= 'bg'
  Catalan	= 'ca'
  Chinese_Simplified = 'zh-CN'
  Chinese_Traditional	= 'zh-TW'
  Croatian = 'hr'
  Czech	= 'cs'
  Danish = 'da'
  Dutch	= 'nl'
  English	= 'en'
  Estonian = 'et'
  Filipino = 'tl'
  Finnish = 'fi'
  French = 'fr'
  Galician = 'gl'
  German = 'de'
  Greek	= 'el'
  Haitian_Creole = 'ht'
  Hebrew = 'iw'
  Hindi	= 'hi'
  Hungarian	= 'hu'
  Icelandic	= 'is'
  Indonesian = 'id'
  Irish	= 'ga'
  Italian	= 'it'
  Japanese = 'ja'
  Latvian = 'lv'
  Lithuanian = 'lt'
  Macedonian = 'mk'
  Malay = 'ms'
  Maltese	= 'mt'
  Norwegian = 'no'
  Persian = 'fa'
  Polish = 'pl'
  Portuguese = 'pt'
  Romanian = 'ro'
  Russian = 'ru'
  Serbian	= 'sr'
  Slovak = 'sk'
  Slovenian = 'sl'
  Spanish	= 'es'
  Swahili	= 'sw'
  Swedish	= 'sv'
  Thai = 'th'
  Turkish	= 'tr'
  Ukrainian	= 'uk'
  Vietnamese = 'vi'
  Welsh = 'cy'
  Yiddish = 'yi'
  
  # This method will look up a particular symbol and
  # try to return a correspondind constant as a string
  def self.lookup(symbol)
    result = self.constants.select do |const|
      eval("self::#{const}").eql?(symbol)
    end
    if result.empty?
      raise NameError, "Looks like '#{symbol}' is not a symbol of a supported language"
    else
      result.to_s
    end
  end
  
end