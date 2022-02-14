# frozen_string_literal: true
class PaginationWrapper
  DEFAULT_PER_PAGE = 10

  attr_accessor :relation
  attr_reader :serializer_class

  def initialize(relation, serializer_class)
    raise ArgumentError, "Collection should be type of ActiveRecord::Relation" unless relation.is_a? ActiveRecord::Relation

    @serializer_class = serializer_class
    @relation = relation
  end

  def per(max_records_number = DEFAULT_PER_PAGE)
    @relation = @relation.per(max_records_number)
    self
  end

  def page(page_number)
    @relation = @relation.page(page_number)
    self
  end

  def result(serialization_scope = {})
    {
      total_pages: relation.total_pages,
      records: ActiveModel::Serializer::CollectionSerializer.new(relation, serializer: serializer_class, scope: serialization_scope),
      current_page: relation.current_page,
      total_count: relation.total_count
    }
  end
end
