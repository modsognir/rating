# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rate' do
  let!(:author)  { create :author }
  let!(:article) { create :article }

  context 'with no scopeable' do
    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:create).with author: author, resource: article, scopeable: nil, value: 3

      author.rate article, 3
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:create).with author: author, resource: article, scopeable: category, value: 3

      author.rate article, 3, scope: category
    end
  end
end
