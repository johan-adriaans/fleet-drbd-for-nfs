resource r0 {
  protocol C;
  device    /dev/drbd1;
  disk      /dev/sdxxx;
  meta-disk internal;

  handlers {
    pri-on-incon-degr "/usr/lib/drbd/notify-pri-on-incon-degr.sh; /usr/lib/drbd/notify-emergency-reboot.sh; echo b > /proc/sysrq-trigger ; reboot -f";
    pri-lost-after-sb "/usr/lib/drbd/notify-pri-lost-after-sb.sh; /usr/lib/drbd/notify-emergency-reboot.sh; echo b > /proc/sysrq-trigger ; reboot -f";
    local-io-error "/usr/lib/drbd/notify-io-error.sh; /usr/lib/drbd/notify-emergency-shutdown.sh; echo o > /proc/sysrq-trigger ; halt -f";
    initial-split-brain "/usr/lib/drbd/notify-split-brain.sh root";
    split-brain "/usr/lib/drbd/notify-split-brain.sh root";
    out-of-sync "/usr/lib/drbd/notify-out-of-sync.sh root";
  }
  syncer {
    verify-alg sha1;
  }
  net {
    cram-hmac-alg sha1;
    shared-secret "%DRBD_SECRET%";
    after-sb-0pri discard-least-changes;
    after-sb-1pri discard-secondary;
    after-sb-2pri call-pri-lost-after-sb;
  }
  disk {
    resync-rate 35M;
  }
  on %DRBD_HOSTNAME_1% {
    address   %DRBD_ADDRESS_1%;
  }
  on %DRBD_HOSTNAME_2% {
    address   %DRBD_ADDRESS_2%;
  }
}
