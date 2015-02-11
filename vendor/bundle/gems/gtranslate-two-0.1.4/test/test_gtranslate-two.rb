require 'helper'

class TestGtranslateTwo < Test::Unit::TestCase
  
  source = GLanguage::English
  target = GLanguage::Danish
  query = 'Hello world!'
  expected_danish_translation = 'Hej Verden!'
  correct_key = 'AIzaSyCb2FdHRnpzFMei4qYAD6AOwgjOAYS1ZlY'
  
  # Eliminating unexpected behaviors
  
  should 'frown on an incorrect language' do
    assert_raise(NameError, 'Oh noes, you should not be able to translate from Klingon') do
      target = GLanguage::Klingon
    end
  end
  
  should 'not lookup an incorrect language' do
    assert_raise(NameError, 'Oh noes, you should not be able to look up Klingon') do
      result = GLanguage.lookup('kl')
    end
  end
  
  should 'not work with an incorrect key' do 
    GTranslator.key = 'test_key'
    result = GTranslator.translate(query, target, source)
    assert_instance_of(Net::HTTPBadRequest, result, 'Oh noes, you can translate with an incorrect key')
  end
  
  should 'not work no parameters' do
    GTranslator.key = correct_key
    assert_raise(ArgumentError, 'Oh noes, you should not be able to translate without parameters') do
      result = GTranslator.translate()
    end
  end
  
  should 'not work just one parameter' do
    GTranslator.key = correct_key
    assert_raise(ArgumentError, 'Oh noes, you should not be able to translate without parameters') do
      result = GTranslator.translate(query)
    end
  end
  
  should 'not work with a manually entered crazy language' do
    GTranslator.key = correct_key
    result = GTranslator.translate(query, 'kl')
    assert_instance_of(Net::HTTPBadRequest, result, 'Oh noes, you could attempt to translate from an unsupported language')
  end
  
  # Checking for expected behaviors
  
  should 'be able to set and return an API key' do
    GTranslator.key = 'test_key'
    assert_equal GTranslator.key, 'test_key', 'Oh noes, key saved incorrectly'
  end
  
  should 'be able to return a translation with both source and target langauge provided' do
    GTranslator.key = correct_key
    result = GTranslator.translate(query, target, source)
    assert(
      result.is_a?(GTranslatorResult) || result.first.is_a?(GTranslatorResult), 
      'Result is neither a GTranslatorResult nor an Array of those'
    )
  end
  
  should 'provide a correct translation with both source and target langauge provided' do
    GTranslator.key = correct_key
    result = GTranslator.translate(query, target, source)
    assert_equal result.translation, expected_danish_translation, 'Oh noes, translation incorrect'
  end
  
  should 'be able to return a translation with only the target langauge provided' do
    GTranslator.key = correct_key
    result = GTranslator.translate(query, target)
    assert(
      result.is_a?(GTranslatorResult) || result.first.is_a?(GTranslatorResult), 
      'Result is neither a GTranslatorResult nor an Array of those'
    )
  end
  
  should 'provide a correct translation with only the target langauge provided' do
    GTranslator.key = correct_key
    result = GTranslator.translate(query, target)
    assert_equal result.translation, expected_danish_translation, 'Oh noes, translation incorrect'
  end
  
  should 'correctly detect a language' do
    GTranslator.key = correct_key
    result = GTranslator.detect_language(query)
    assert_equal result, source, 'Oh noes, translation incorrect'
  end
  
  should 'look up the language constant correctly' do
    result = GLanguage.lookup(GLanguage::Danish)
    assert_equal result, 'Danish', 'Oh noes, lookup failed'
  end
  
end
