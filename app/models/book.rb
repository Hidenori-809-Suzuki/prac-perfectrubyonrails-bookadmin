class Book < ApplicationRecord
    scope :costly, -> { where("price > ?", 3000)}
    scope :written_about, ->(theme){ where("name like ?", "%#{theme}%")}

    belongs_to :publisher
    has_many :book_authors
    has_many :authors, through: :book_authors

    validates :name, presence: true # 本の名前は必須
    validates :name, length: { maximum: 25 } # 名前は25文字まで
    validates :price, numericality: { greater_than_or_equal_to: 0 } # 価格は0以上で
    validate do |book| # 独自のバリデーションを追加_2-2-3
        if book.name.include?("exercises")
            book.errors[:name] << "I don't like exercise."
        end
    end

    before_validation do
        self.name = self.name.gsub(/Cat/) do |matched|
            "lovely #{matched}"
        end
    end

    after_destroy do
        Rails.logger.info "Book is deleted: #{self.attributes}"
    end

    after_destroy :if => :high_price? do
        Rails.logger.warn "Book with high price is deleted: #{self.attributes}"
        Rails.logger.warn "Please check!!"
    end

    def high_price?
        price >= 5000
    end
end
