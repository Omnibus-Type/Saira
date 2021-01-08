from typing import Any, Callable, Dict, List, Literal, Set, Type, _GenericAlias

from cattr import Converter


def make_literal_structure_fn(
    converter: Converter, *classes: Type,
) -> Callable[[Dict, Type], Any]:
    """
    Given a sequence of attrs classes, each of which has a different Literal
    field, generate a union structuring function.
    """
    # First, find the field with the literal.
    literal_fields: List[Set[str]] = []

    for cls in classes:
        lits = set()
        for attr in cls.__attrs_attrs__:
            t = attr.type
            if isinstance(t, _GenericAlias) and t.__origin__ is Literal:
                lits.add(attr.name)
        literal_fields.append(lits)
    field = next(iter(set.intersection(*literal_fields)))

    cls_mapping = {
        getattr(cls.__attrs_attrs__, field).type.__args__[0]: cls
        for cls in classes
    }

    def union_literal_hook(obj: Dict, _: Type):
        val = obj[field]
        try:
            cls = cls_mapping[val]
        except KeyError:
            raise Exception(f"No class matches literal {val}.")
        return converter.structure(obj, cls)

    return union_literal_hook
