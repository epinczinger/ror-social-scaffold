require 'rails_helper'

RSpec.describe User, type: :model do

    context 'Associations' do
        it 'does have association with friendships model' do
            association = User.reflect_on_association(:friendships)
            expect(association.macro).to eq(:has_many)
        end

        it 'does have association with post model' do
            association = User.reflect_on_association(:posts)
            expect(association.macro).to eq(:has_many)
        end
    end

    context 'Validations' do
        it 'must have name' do
            new_user = User.new(email: 'ert@hg.com', password: '123123')
            expect(new_user.save).to eq(false)
        end

        it 'must have email' do
            new_user = User.new(name: 'Esteban', password: '123123')
            expect(new_user.save).to eq(false)
        end

        it 'must have password' do
            new_user = User.new(name: 'Esteban', email: 'ert@hg.com')
            expect(new_user.save).to eq(false)
        end

        it 'should save having name, email and password' do
            new_user = User.new(name: 'Esteban', email: 'ert@hg.com', password: '123123')
            expect(new_user.save).to eq(true)
        end

        it 'name length has to be minor than 20 char' do
            new_user = User.new(name: 'Thisisaveryveryverylongname', email: 'ert@hg.com', password: '123123')
            expect(new_user.save).to eq(false)
        end

    end

end