# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe DirProcessor do

  it 'should capture all files' do
    files = []
    dp    = DirProcessor.new { |f| files << f }
    dp.process(FIXTURES)

    # puts files
    expect(files.length).to be == 8
  end

end
