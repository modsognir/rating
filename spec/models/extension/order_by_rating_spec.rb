# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':order_by_rating' do
  let!(:category) { create :category }

  let!(:author_1) { create :author }
  let!(:author_2) { create :author }

  let!(:article_1) { create :article }
  let!(:article_2) { create :article }
  let!(:article_3) { create :article }

  before do
    create :rating_rate, author: author_1, resource: article_1, value: 100
    create :rating_rate, author: author_1, resource: article_2, value: 11
    create :rating_rate, author: author_1, resource: article_3, value: 10
    create :rating_rate, author: author_2, resource: article_1, value: 1

    create :rating_rate, author: author_1, resource: article_1, scopeable: category, value: 1
    create :rating_rate, author: author_2, resource: article_1, scopeable: category, value: 2
  end

  context 'with default filters' do
    it 'sorts by :estimate :desc' do
      expect(Article.order_by_rating).to eq [
        article_1,
        article_2,
        article_3
      ]
    end
  end

  context 'filtering by :average' do
    context 'as asc' do
      it 'works' do
        expect(Article.order_by_rating(:average, :asc)).to eq [
          article_3,
          article_2,
          article_1
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Article.order_by_rating(:average, :asc, scope: category)).to eq [
            article_1
          ]
        end
      end
    end

    context 'as desc' do
      it 'works' do
        expect(Article.order_by_rating(:average, :desc)).to eq [
          article_1,
          article_2,
          article_3
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Article.order_by_rating(:average, :desc, scope: category)).to eq [
            article_1
          ]
        end
      end
    end
  end

  context 'filtering by :estimate' do
    context 'as asc' do
      it 'works' do
        expect(Article.order_by_rating(:estimate, :asc)).to eq [
          article_3,
          article_2,
          article_1
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Article.order_by_rating(:estimate, :asc, scope: category)).to eq [
            article_1
          ]
        end
      end
    end

    context 'as desc' do
      it 'works' do
        expect(Article.order_by_rating(:estimate, :desc)).to eq [
          article_1,
          article_2,
          article_3
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Article.order_by_rating(:estimate, :desc, scope: category)).to eq [
            article_1
          ]
        end
      end
    end
  end

  context 'filtering by :sum' do
    context 'as asc' do
      it 'works' do
        expect(Article.order_by_rating(:sum, :asc)).to eq [
          article_3,
          article_2,
          article_1
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Article.order_by_rating(:sum, :asc, scope: category)).to eq [
            article_1
          ]
        end
      end
    end

    context 'as desc' do
      it 'works' do
        expect(Article.order_by_rating(:sum, :desc)).to eq [
          article_1,
          article_2,
          article_3
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Article.order_by_rating(:sum, :desc, scope: category)).to eq [
            article_1
          ]
        end
      end
    end
  end

  context 'filtering by :total' do
    context 'as asc' do
      it 'works' do
        result = Article.order_by_rating(:total, :asc)

        expect(result[0..1]).to match_array [article_2, article_3]
        expect(result.last).to  eq article_1
      end

      context 'with scope' do
        it 'works' do
          expect(Article.order_by_rating(:total, :asc, scope: category)).to eq [
            article_1
          ]
        end
      end
    end

    context 'as desc' do
      it 'works' do
        result = Article.order_by_rating(:total, :desc)

        expect(result.first).to eq article_1
        expect(result[1..2]).to match_array [article_2, article_3]
      end

      context 'with scope' do
        it 'works' do
          expect(Article.order_by_rating(:total, :desc, scope: category)).to eq [
            article_1
          ]
        end
      end
    end
  end

  context 'with other resource' do
    it 'works' do
      expect(Author.order_by_rating(:total, :desc)).to match_array [author_1, author_2]
    end

    context 'with scope' do
      it 'returns empty since creation has no scope' do
        expect(Author.order_by_rating(:total, :desc, scope: category)).to eq []
      end
    end
  end
end
