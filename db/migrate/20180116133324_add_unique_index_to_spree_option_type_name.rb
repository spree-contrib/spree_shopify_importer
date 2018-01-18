class AddUniqueIndexToSpreeOptionTypeName < SpreeExtension::Migration[4.2]
  def change
    return if check_lower_index_exists?

    attributes = Spree::OptionType.unscoped.group(:name).having('sum(1) > 1').pluck(:name)
    instances = Spree::OptionType.where(name: [nil, attributes])

    instances.find_each do |instance|
      column_value = "#{instance.name} #{SecureRandom.urlsafe_base64(8).upcase.delete('/+=_-')[0, 8]}"
      instance.update(name: column_value)
    end

    remove_index :spree_option_types, :name if index_exists?(:spree_option_types, :name)
    if supports_expression_index?
      add_index :spree_option_types, 'lower(name)', unique: true
    else
      add_index :spree_option_types, :name, unique: true
    end
  end

  private

  def check_lower_index_exists?
    if supports_expression_index?
      ActiveRecord::Base.connection.indexes(:spree_option_types).any? do |struct|
        struct.columns.eql?('lower((name)::text)')
      end
    else
      index_exists?(:spree_option_types, :name, unique: true)
    end
  end
end
