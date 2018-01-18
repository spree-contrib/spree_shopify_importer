class AddUniqueIndexToSpreeOptionValueName < SpreeExtension::Migration[4.2]
  def change
    return if check_lower_index_exists?

    attributes = Spree::OptionValue.unscoped.group(:name, :option_type_id).having('sum(1) > 1').pluck(:name,
                                                                                                      :option_type_id)
    instances = Spree::OptionValue.where(name: [nil, attributes[0]], option_type_id: attributes[1])

    instances.find_each do |instance|
      column_value = "#{instance.name} #{SecureRandom.urlsafe_base64(8).upcase.delete('/+=_-')[0, 8]}"
      instance.update(name: column_value)
    end

    remove_index :spree_option_values, :name if index_exists?(:spree_option_values, %i[name option_type_id])
    if supports_expression_index?
      add_index :spree_option_values, 'lower(name), option_type_id', unique: true
    else
      add_index :spree_option_values, %i[name option_type_id], unique: true
    end
  end

  private

  def check_lower_index_exists?
    if supports_expression_index?
      ActiveRecord::Base.connection.indexes(:spree_option_values).any? do |struct|
        struct.columns.eql?('lower((name)::text, option_type_id)')
      end
    else
      index_exists?(:spree_option_values, %i[name option_type_id], unique: true)
    end
  end
end
