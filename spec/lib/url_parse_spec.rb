require 'spec_helper'
require 'url_parse'

RSpec.describe 'UrlParse' do
  let(:url_string) {'lalit-kumar-martian-birthday-on-1994-04-17'}
  
  VALID_URLS = [
    'lalit-kumar-martian-birthday-on-1994-04-17',
    'lalit-kumar-oioaweadasd-dasd-asd-asd-ada-martian-birthday-on-1994-04-17',
    'l-martian-birthday-on-birthday-on-1994-04-17',
    '-martian-birthday-on-birthday-on-1994-04-17',
    'martian-birthday-on-1994-04-17'
  ]

  INVALID_URLS = [
    'lalit-kumar-martian-birthday-oo-1994-04-17',
    'lalit-martian-birday-on-1994-04-17',
    'lalit-martian-birday-1994-04-17',
    'lalit-martian-1994-04-17',
    'lalit-1994-04-17'
  ]

  before(:each) do
    @url_parse = UrlParse.new(url_string)
  end

  shared_examples_for :valid_urls do |argument|
    it { expect(@url_parse.validate_url).to eq(argument) }
  end  

  context 'Valid URL' do      
    VALID_URLS.each do |url|      
      context 'parses url' do         
        let(:url_string) { url }
        it_behaves_like :valid_urls, true
      end  
    end
  end

  context 'Invalid URL' do      
    INVALID_URLS.each do |url|      
      context 'parses url' do         
        let(:url_string) { url }
        it_behaves_like :valid_urls, nil
      end  
    end
  end

  shared_examples_for :parse_url do |key, value|
    let(:url_string) { 'lalit-kumar-martian-birthday-on-1994-04-17' }
    it { expect(@url_parse.parse[key]).to eq(value) }
  end 

  context 'Parse Name' do
    it_behaves_like :parse_url, :name, 'lalit-kumar'
  end

  context 'Parse Birthday' do
    it_behaves_like :parse_url, :birthday, '1994-04-17'
  end

  shared_examples_for :valid_hash do |key|
    let(:url_string) { 'lalit-kumar-martian-birthday-on-1994-04-17' }
    it { expect(@url_parse.parse.has_key?(key)).to eq(true) }
  end

  context "Valid Hash" do
    let(:url_string) { 'lalit-kumar-martian-birthday-on-1994-04-17' }
    it_behaves_like :valid_hash, :name
    it_behaves_like :valid_hash, :birthday
  end
end