This application is an example implementation of a remote restful api for use with [poetic:rest-sync](https://github.com/poetic/meteor-rest-sync) meteor package.

## Overview
This application works by making avaliable the JSON endpoints for the meteor application to submit to, and the index to fetch from.  The meteor side will have rest endpoint's setup for immediatly propogating changes made on the rails side.  Updates and inserts are document level, and in the case of conflict, the most recent timestamp is preferred.

## Requirements

### Insert

An external_id field is needed on the rails side, that can be stored for certain edge case's.  The index route should accept "external_id" as a parameter and return documents (should be one) that match.

### Update

The last updated time needs to be tracked for the polling fallback, and the index should accept the "updated_since" parameter to return recent changes.

### Delete

Delete operations should result in a field change that will mark the document as deleted rather than actually deleting the document.  This can be achieved through the [paranoia](https://github.com/radar/paranoia) or your own custom implementation.

### Realtime mode

To achieve a more realtime sync between the applications, you may optionally call meteor's restful endpoints directly.  Delete is just an update operation, where the deleted_at field is updated.