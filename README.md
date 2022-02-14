Everything (okay, maybe solid part) is a tradeoff in the software development :)

This test task is not an exception. There are of course places which could be improved/implemented another way and I'll be happy to discuss them.

List of things I think could be discussed:
- separate endpoint for Bearer creation
- using serializers in this particular case (overcomplicated, but it's done on purpose), default rails `.to_json` with `only` and `include` also works here.
- selection of gems: kaminari, active_model_serializers(!).
- tests coverage: not all files are covered but seems like in this particular case it's not needed.
- pagination in `index` action.
- DB indexes.
- size of `spec/controllers/stocks_controller_spec.rb`.
- depending on required fields in update action it can be rewritten in a different way.
- ways to generate API documentation (there are plenty of them).
