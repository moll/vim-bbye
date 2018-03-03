## Unreleased
- Adds `:Bwipeout`. Thanks, [Juan Ibiapina](http://juanibiapina.com)!
- Fixes `:Bdelete`ing an already unlisted buffer.  
  That happens when you close a buffer that itself closes when switched away from.  
  Thanks, [Samuel Simões](http://blog.samuelsimoes.com), for debugging help!

## 1.0.1 (Jul 23, 2013)
- Fixes `:Bdelete`ing via buffer number. Finally, perfect!

## 1.0.0 (Jul 23, 2013)
- Hides the empty buffer from buffer explorers and tabbars.
- Handles `:Bdelete!`ing buffers which are set to auto-delete via `&bufhidden`.
- Wipes empty buffers after hiding to reduce the amount of unlisted buffers after using Bbye for a while.
- Handles buffer explorers and tabbars better that remove or add windows mid-flight.
- Improves an edge-case where the empty buffer might get listed and show up in buffer explorers.
- Perfect for v1.0.0.

## 0.9.1 (Jul 21, 2013)
- Removes an innocent but forgotten debugging line. Now even more perfect.

## 0.9.0 (Jul 21, 2013)
- First release. It's perfect.
