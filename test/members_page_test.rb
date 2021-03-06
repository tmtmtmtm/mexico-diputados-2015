# frozen_string_literal: true

require_relative './test_helper'
require_relative '../lib/members_page.rb'

describe 'MembersPage' do
  around { |test| VCR.use_cassette('Members Page', &test) }
  let :members_page do
    url = 'http://sitl.diputados.gob.mx/LXIII_leg/listado_diputados_gpnp.php?tipot=TOTAL'
    MembersPage.new(response: Scraped::Request.new(url: url).response)
  end

  describe 'member rows' do
    subject do
      members_page.party_groupings.flat_map(&:members).find { |mem| mem.id == id }
    end

    describe 'member row with area type: distrito' do
      let(:id) { '260' }

      it 'should have the expected data' do
        subject.to_h.must_equal(
          id:        id,
          sort_name: 'Abdala Carmona Yahleel',
          source:    'http://sitl.diputados.gob.mx/LXIII_leg/curricula.php?dipt=260',
          area:      'Tamaulipas 1',
          area_id:   'ocd-division/country:mx/entidad:tamaulipas/distrito:1'
        )
      end
    end

    describe 'member row with area type: circunscripción' do
      let(:id) { '500' }

      it 'should have the expected data' do
        subject.to_h.must_equal(
          id:        id,
          sort_name: 'Perea Santos Ana Guadalupe',
          source:    'http://sitl.diputados.gob.mx/LXIII_leg/curricula.php?dipt=500',
          area:      'Hidalgo 5',
          area_id:   'ocd-division/country:mx/entidad:hidalgo/circunscripción:5'
        )
      end
    end
  end

  describe 'party groupings' do
    subject do
      members_page.party_groupings.first
    end

    it 'should contain a party grouping with the correct name' do
      subject.party.must_equal 'Partido Revolucionario Institucional'
    end

    it 'should contain a party grouping with the correct id' do
      subject.party_id.must_equal 'PRI'
    end

    it 'should contain a party grouping with the correct number of members' do
      subject.members.count.must_equal 207
    end
  end
end
