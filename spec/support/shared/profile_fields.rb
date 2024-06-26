shared_examples 'fields returnable' do
  it 'returns all public fields' do
    %w(id email admin created_at updated_at).each do |attr|
      expect(json_item[attr]).to eq user_item.public_send(attr).as_json
    end
  end

  it 'does not return private fields' do
    %w(password encrypted_password).each do |attr|
      expect(json_item).to_not have_key(attr)
    end
  end
end
