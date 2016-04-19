require 'spec_helper'

describe Kumamoto do
  it 'has a version number' do
    expect(Kumamoto::VERSION).not_to be nil
  end

  it 'has a http user agent' do
    expect(Kumamoto::HTTP_USER_AGENT).not_to be nil
  end
end
