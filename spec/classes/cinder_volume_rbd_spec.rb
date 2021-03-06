require 'spec_helper'

describe 'cinder::volume::rbd' do
  let :req_params do
    {
      :rbd_pool              => 'volumes',
      :glance_api_version    => '2',
      :rbd_user              => 'test',
      :rbd_secret_uuid       => '0123456789',
    }
  end

  it { should contain_class('cinder::params') }

  let :params do
    req_params
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  describe 'rbd volume driver' do
    it 'configure rbd volume driver' do
      should contain_cinder_config('DEFAULT/volume_driver').with_value(
        'cinder.volume.drivers.rbd.RBDDriver')
      should contain_cinder_config('DEFAULT/rbd_pool').with_value(
        'volumes')
      should contain_cinder_config('DEFAULT/rbd_user').with_value(
        'test')
      should contain_cinder_config('DEFAULT/rbd_secret_uuid').with_value(
        '0123456789')
      should contain_file_line('set initscript env').with(
        :line    => /env CEPH_ARGS=\"--id test\"/,
        :path    => '/etc/init/cinder-volume.override',
        :require => 'Package[cinder-volume]',
        :notify  => 'Service[cinder-volume]')
    end
  end

  describe 'with RedHat' do
    let :facts do
        { :osfamily => 'RedHat' }
    end

    let :params do
      req_params
    end

    it 'should configure RedHat init override' do
      should contain_file_line('set initscript env').with(
        :line    => /export CEPH_ARGS=\"--id test\"/,
        :path    => '/etc/sysconfig/openstack-cinder-volume',
        :require => 'Package[cinder-volume]',
        :notify  => 'Service[cinder-volume]')
    end
  end

end

