import yoga from 'yoga-layout';

import './build-browser.hxml';
window.__yoga = yoga;
document.dispatchEvent(new Event('yogaReady'));
