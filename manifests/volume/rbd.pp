#
class cinder::volume::rbd (
  $rbd_pool          = 'volumes',
  $rbd_user          = 'volumes',
  $rbd_secret_uuid
) {

  include cinder::params

  cinder_config {
    'DEFAULT/volume_driver':    value => 'cinder.volume.driver.RBDDriver';
    'DEFAULT/rbd_pool':         value => $rbd_pool;
    'DEFAULT/rbd_user':         value => $rbd_user;
    'DEFAULT/rbd_secret_uuid':  value => $rbd_secret_uuid;
   }
}
