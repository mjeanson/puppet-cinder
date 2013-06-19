#
class cinder::volume::rbd (
  $rbd_pool          = 'volumes',
  $rbd_user          = 'volumes',
  $rbd_secret_uuid
) {

  include cinder::params

  file {"/etc/init/cinder-volume.override":
    content => "env CEPH_ARGS=\"--id ${rbd_user}\"",
    require => Package['cinder'],
    notify  => Service['cinder-volume']
  }

  cinder_config {
    'DEFAULT/volume_driver':    value => 'cinder.volume.drivers.rbd.RBDDriver';
    'DEFAULT/rbd_pool':         value => $rbd_pool;
    'DEFAULT/rbd_user':         value => $rbd_user;
    'DEFAULT/rbd_secret_uuid':  value => $rbd_secret_uuid;
   }
}
